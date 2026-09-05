class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.2.2.tar.gz"
  sha256 "9f9d0236bf0751cb4f5d747c077697f396546ba1ad8653c2e9b7192ea47df14a"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9dc45bb5c7eff6eee31605eefee286ba5d9a1240fc758a72da81ea0e0e7170c"
    sha256 cellar: :any, arm64_sequoia: "9d13c377975426b6b530f3b8f09afc0e4b4bf628e1443489f69257ea9b1d93ca"
    sha256 cellar: :any, arm64_sonoma:  "0e218fccdf4bc62ef814fd8eaa0021ae52a27927798e831e5489c23b0bfd8229"
    sha256 cellar: :any, arm64_linux:   "f144db41fa0559506091621e1ceb429aad9ee7dc93f945b84e9029da11aa90b3"
    sha256 cellar: :any, x86_64_linux:  "1078d725e00e6dd2530ddae37ed4e8af0bd221ab3944170f26d8d3cd3ce9e48c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
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
