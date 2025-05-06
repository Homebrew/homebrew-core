class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r60.tar.gz"
  sha256 "706aa05c888b53bd170e5d8aa8f8a9d9ccf5449dfed262d5103d1f292af26774"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d733ad23333784e6543acd42a009e285ac26022be060618ff6bd22ed79090a45"
    sha256 cellar: :any,                 arm64_sonoma:  "33fb4ad64115e9d2505de9b3a25799b36ab5fc787e7ffed3f782cd07f1823ea0"
    sha256 cellar: :any,                 arm64_ventura: "703fa07d9b11ef46f41717d8c84830a6e23142048e3854819df6836633b483eb"
    sha256 cellar: :any,                 sonoma:        "824e3faaaabd542a7766f86bcc74c76f3c9613da1b84afca8fa6df5ce16156a2"
    sha256 cellar: :any,                 ventura:       "79702e0e934119b994574bb0c16953a8e7f77294f742a63d8ba6a6386b1f4765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27fbd099baf0e6f942cff29f191f8cba0dad5a854f61f93ad9e23f88e83eafa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49344a3a05193407903d38f32aff19acd16390490455f544c0417901c394e186"
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
