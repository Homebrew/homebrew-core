class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r62.tar.gz"
  sha256 "9c15fa751bb8093d042dae1b9f125eb45198c32c6704cd5481ccde460d4f8151"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2da037de9e1fcd435b7f6ce72ad3f4d68daba4309177706b4985cb1a8b177410"
    sha256 cellar: :any,                 arm64_sequoia: "091fb8df3a4b359eb9901ca5cbbb3c933884eb7c5ae8f3501cfbe42bf45c9310"
    sha256 cellar: :any,                 arm64_sonoma:  "2e705b5f3bfd341b9d6f482bbaeee593d2471e89b39b676f8c2a343121fe0c96"
    sha256 cellar: :any,                 arm64_ventura: "1275d4633d996f2ebeb3ef1caaccf602fa379f8fae6bc5de7c5861734eeb4add"
    sha256 cellar: :any,                 sonoma:        "e0b9bac4889b98ae4d76744dad465896324f24d3c6cf153da61dc4ab7c47bdc6"
    sha256 cellar: :any,                 ventura:       "ca38d47aaad57936c7f35f0717c88f137ebecfc736eb77420451cc00b884d73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367d03ca8de872326f20c9fdc0e51c1f067c2ad3a7c6f256e808a8290402270b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009e69d397acb943997e1a240c2f7836343aa8ddbec03fc9eda1f4192b211205"
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
