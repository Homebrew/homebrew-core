class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r57.tar.gz"
  sha256 "f03f98ca35c3adb56b2358573c8d3eda319ccd5287243d691e724b7eafa970b3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83e40eadfcc9e82827f9362cb096bbe1a3981ced363176e8c9302d652a00ca8c"
    sha256 cellar: :any,                 arm64_monterey: "001ee6ba12164e738596ef82997f20fbff5f294ec87f19938d366b1b9c9a39a6"
    sha256 cellar: :any,                 arm64_big_sur:  "ecda1c6e35982227486a058b6ca24a25f2a0940db5dc888d76f51014a7890140"
    sha256 cellar: :any,                 ventura:        "58d4d12cd171b910f3ce583fe89cd99299628af9d72466e50d04bc1da1be01ad"
    sha256 cellar: :any,                 monterey:       "fbc1662368467136569d18f316ef473943c165a4a6ba5fdc783788533f71a2a4"
    sha256 cellar: :any,                 big_sur:        "3fef066c8824e259abf50cf8a1f1bb647ec09edae68e5d5bdd70d639027bf921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27431f7f23ab770703972c03dc4324d82d1805c27f384ccbd3b40cedda4ec6a6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dcpp_std=c++11", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
