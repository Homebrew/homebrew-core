class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.0.0.tar.gz"
  sha256 "27dbb0b23c4d94018c764c429f7d6222b2736ffa7b9e101f746bc827c3bf83a0"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "f7b1e00ac4c2948a24c54955d254938b9a3ae8af47a477df4bb6badae9f14f39"
    sha256 arm64_sequoia: "121bcd357125ab7002a4cbb8411e9ff6b2ce9ecc1a359e69ed37c601205a48d9"
    sha256 arm64_sonoma:  "5ef89d2d97ef43dacfb7d3e439eeb4fdf1f1adc9d13e19a2dc0ba5c4571f4371"
    sha256 sonoma:        "c0aed585dbbceb78a37af319bd74be9c58a9de6eb59e79d8c7d8d72d5b22d7eb"
    sha256 arm64_linux:   "edd556206477844c1555d63a5d976ef7ad29ecc3c3e3f2980958fb84de534cd5"
    sha256 x86_64_linux:  "0489f2c3ba1362f7858dfa31c3e79ce65c073fc268cea0d9bd9ee6d5e3cde8b3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    # Patch build.rs to use Homebrew's libexec path instead of /usr/local/libexec
    inreplace "bear/build.rs",
      'WRAPPER_EXECUTABLE_PATH=/usr/local/libexec/bear/wrapper");',
      "WRAPPER_EXECUTABLE_PATH=#{libexec}/bear/wrapper\");"

    inreplace "bear/build.rs",
      'PRELOAD_LIBRARY_PATH=/usr/local/libexec/bear/$LIB/libexec.so");',
      "PRELOAD_LIBRARY_PATH=#{libexec}/bear/$LIB/libexec.so\");"

    mkdir_p libexec/"bear"

    system "cargo", "install", *std_cargo_args(path: "intercept-wrapper", root: libexec)
    mv "#{libexec}/bin/wrapper", "#{libexec}/bear/wrapper"

    system "cargo", "install", *std_cargo_args(path: "bear")
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
