class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.2.3.tar.gz"
  sha256 "7c3901786f01da60d606cc80afdda36e866259b78e1dd7f890fd42cee64d3574"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2c445a926e272eb3ead9bdff8a2e4d3b62c7533baba77a8dbbd998541370b757"
    sha256 cellar: :any, arm64_tahoe:       "7353e6f874632db78f123de076a7b30bd9015cd9fef74a01268e0045397a093b"
    sha256 cellar: :any, arm64_sequoia:     "8b78d97468c9ab433b9df184d5b5bdc7f28b93473e3d7cd46296a6496c10c97b"
    sha256 cellar: :any, arm64_linux:       "fb9c0b47e5bd2b286f23e570362cdf1a2df6f093f6a7b345f5c50eeaf8ab6de8"
    sha256 cellar: :any, x86_64_linux:      "89693fb1a122301d8600c0a226d0eb89ae704ba9535e3633d902fd20ad09f052"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    %w[driver wrapper].each do |crate|
      # Install binaries to `target/release` because `scripts/install.sh` expects them here
      system "cargo", "install", *std_cargo_args(root: "target/release", path: "crates/bear-#{crate}")
    end
    ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld" if OS.linux?
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
