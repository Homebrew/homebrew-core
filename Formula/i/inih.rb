class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r63.tar.gz"
  sha256 "5d7967de62c5bfdc4f9f5ab06ce44c9e498bae021c7dac5792c0696e76aa9963"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1393317f2266668755f0083810c0031dbd3ad3f0a1024047182b6a6549ad0b1"
    sha256 cellar: :any, arm64_tahoe:       "c42c2039c1b759785f9144d4e886360c1123beb1292d77994dc241e928819d8c"
    sha256 cellar: :any, arm64_sequoia:     "b05b2e6544c764c64a0c0963c66f05cbd9ee1fd481942a3af0cbc130a37f45fe"
    sha256 cellar: :any, arm64_linux:       "fb4c70b44176e5ce6e6c1c0449eb4798328a0d07faa069f7c9da982409d17f64"
    sha256 cellar: :any, x86_64_linux:      "15b361c3631a469358fd4c2cdf738da2c9fd0e152426391508c565cd9029e468"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dcpp_std=c++11", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <ini.h>

      static int dumper(void* user, const char* section, const char* name, const char* value) {
          static char prev_section[50] = "";
          if (strcmp(section, prev_section)) {
              printf("%s[%s]\\n", (prev_section[0] ? "\\n" : ""), section);
              strncpy(prev_section, section, sizeof(prev_section));
              prev_section[sizeof(prev_section) - 1] = '\\0';
          }
          printf("%s = %s\\n", name, value);
          return 1;
      }

      int main(int argc, char* argv[]) {
          if (argc <= 1) {
              return 1;
          }

          int error = ini_parse(argv[1], dumper, NULL);
          if (error < 0) {
              printf("Can't read '%s'!\\n", argv[1]);
              return 2;
          } else if (error) {
              printf("Bad config file (first error on line %d)!\\n", error);
              return 3;
          }
          return 0;
      }
    C

    (testpath/"test.ini").write <<~INI
      [protocol]             ; Protocol configuration
      version=6              ; IPv6

      [user]
      name = Bob Smith       ; Spaces around '=' are stripped
      email = bob@smith.com  ; And comments (like this) ignored
      active = true          ; Test a boolean
      pi = 3.14159           ; Test a floating point number
    INI

    expected = <<~INI
      [protocol]
      version = 6

      [user]
      name = Bob Smith
      email = bob@smith.com
      active = true
      pi = 3.14159
    INI

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-linih", "-o", "test"
    assert_equal expected, shell_output("./test test.ini")
  end
end
