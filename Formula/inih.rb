class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r54.tar.gz"
  sha256 "b5566af5203f8a49fda27f1b864c0c157987678ffbd183280e16124012869869"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4427517fd0fd9ee58cef1bdaee10c99abf83522cc3b3c0aa750d20d6080b742"
    sha256 cellar: :any,                 arm64_big_sur:  "b590c77d00e4d93ada33935c04f976fea1aa736c85cff378cc5180eaf881f485"
    sha256 cellar: :any,                 monterey:       "92fdccdc79ffd515d9a7d038273b54d68d67e818e5d5eb0fdf6373104432e7fe"
    sha256 cellar: :any,                 big_sur:        "695ae960d4c26d0b11e87227319c9e17a9bc5882e169d3d006d13b391f6d821b"
    sha256 cellar: :any,                 catalina:       "e99fa791a1127ab1c205a19176be14e0fb5e7709d0f44525e6a15c30ce639da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6e3860a48e514660ca4bde2724a5b3275f246eec1a25309c0cedfe44875aa6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    (testpath/"test.ini").write <<~EOS
      [protocol]             ; Protocol configuration
      version=6              ; IPv6

      [user]
      name = Bob Smith       ; Spaces around '=' are stripped
      email = bob@smith.com  ; And comments (like this) ignored
      active = true          ; Test a boolean
      pi = 3.14159           ; Test a floating point number
    EOS

    expected = <<~EOS
      [protocol]
      version = 6

      [user]
      name = Bob Smith
      email = bob@smith.com
      active = true
      pi = 3.14159
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-linih", "-o", "test"
    assert_equal expected, shell_output("./test test.ini")
  end
end
