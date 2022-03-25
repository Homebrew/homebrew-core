class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r55.tar.gz"
  sha256 "ba55f8ae2a8caf0653f30f48567241e14ea916acfc13481f502d8a9c8f507f68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2aee36a6e3545037a78000ecb68b049372bfafeca4d5e099732edaeae6ca652c"
    sha256 cellar: :any,                 arm64_big_sur:  "5325549177417afeeadac37bb9f9ac41a9a473d5e02b630841866c2811dbea93"
    sha256 cellar: :any,                 monterey:       "2ec4ede0030148c462a673b654923ca765b3fc99a64f6f8978d8ca1835a2284b"
    sha256 cellar: :any,                 big_sur:        "9003490e3a5106343541963798f2761c44a0f94b0a11e58128a824fd8d70274e"
    sha256 cellar: :any,                 catalina:       "bb1c8a8363bc30003bfb534692ee19e7b14e2219ed8acee60e3493aaed777a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0cefc483d1663181a5825890c0465a2de46740611ccca0afe49a82ed1b92586"
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
