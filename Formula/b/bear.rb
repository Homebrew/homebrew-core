class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.4.tar.gz"
  sha256 "1fd74a9d3c8cc05dd6651d17ab17fca25e62bc92c7739e6ae3260729788d3c58"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0a418daa6159e7b8b4782970ca167cdbdd387f984993c99cbd4a0a24159842a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d88287618f47f219b6fb58ff8b6415003a1bf8b494556ecd45fbdde7e225da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baad8da8289d90a85166289816b30647053224e1028157905077b076cd1c9337"
    sha256 cellar: :any_skip_relocation, sonoma:        "43deec10705926e761f025d3b4b12d4288d40b098c08f99f43f2436ed33c3e32"
    sha256 cellar: :any,                 arm64_linux:   "514c6b5de5e9388e23fca00946c314aaef24feaadd0cd4c7381826c060e4e967"
    sha256 cellar: :any,                 x86_64_linux:  "4e82778df48386c29e7096aaa9cbf236df66c8f440ee5771c9a04373ee21d1d0"
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
