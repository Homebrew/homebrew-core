class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.3.tar.gz"
  sha256 "87a5b385b01000a3ae2c69f535384dca33da7f23925a523ba177f98b1bb7f301"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed93b541ff92545a37b95688a8574062fb5ffd4b108b55d9c6d990a8ded3e17c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d9e963a9252968ecce5ab2a7ceccc237c17f561e5e6c028e65901f8fdb814c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d6907b5487f866d9896e17f569d9a70568a03e5c44489c433fb810b4fbefd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2acfbfea5f874601a01d1a9c8ec8f2828ff6bdfbd8a13be8506f345b4fcdbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a0075af277038a7b07591bc8f0b2743afb57852ef46e5d57d76162fa36df50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaac10ac3a95629db859f754f3e4eb4d9ef743c0cd6841f5ed0f56b89926344d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"
      (libexec/"lib").install "target/release/libexec.so"
    end

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
