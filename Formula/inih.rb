class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r56.tar.gz"
  sha256 "4f2ba6bd122d30281a8c7a4d5723b7af90b56aa828c0e88256d7fceda03a491a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62d63767678a16ba47ca7dcbe47ded6e081fe9f4de657868e9db4abf9cfbdfc8"
    sha256 cellar: :any,                 arm64_monterey: "c58eb0d442cec960657feff64d84a98f936909ee157c8bfc296a020368a0b29c"
    sha256 cellar: :any,                 arm64_big_sur:  "d321facd01bf101f9ab0dfe77e16bb6ffb673f70940af3f7866dee722fcd0f63"
    sha256 cellar: :any,                 ventura:        "55e9f70f34da60eb227bf1b8771891332b3e0d3ecf6320ee44f9f194b5b16dbb"
    sha256 cellar: :any,                 monterey:       "9479af24ebfb40bf0af7b7c932e2a28ee576a6cac5049813046bd77e43057fcc"
    sha256 cellar: :any,                 big_sur:        "8758bc663cf469d9c56332283c2bc1011b193b0358491ff0a0f53388c62adb5e"
    sha256 cellar: :any,                 catalina:       "f046d88bcab9301f78c4de41c70bd543920021f572e4fb1622e81f98b0b7e07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5fcb21fdf047cf73e88c099f4813dd11c2fd63ea1099f07663a842063a8496"
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
