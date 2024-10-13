class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r58.tar.gz"
  sha256 "e79216260d5dffe809bda840be48ab0eec7737b2bb9f02d2275c1b46344ea7b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4c81bf7f96140b151b2341d5549e3760db9f4d60e149fd8152d60b011de298cf"
    sha256 cellar: :any,                 arm64_sonoma:   "5e3feca2ad82149be23f8b8197dc4def4b6f875f913bc20e6a63d0fca2f950e5"
    sha256 cellar: :any,                 arm64_ventura:  "cda39a0bf974dc4a44f1ae643e5d6f68c36625927b40284d923b3b405bdaae67"
    sha256 cellar: :any,                 arm64_monterey: "8c4076b74b74305a3bcb8fed1e48cf12afed174fa133ac270ebea088821479ac"
    sha256 cellar: :any,                 sonoma:         "3a840e0886567281f23a8567e9b89fa47c1bb3512ba19daac9867bc97220ee44"
    sha256 cellar: :any,                 ventura:        "62e0def050a8c72d642df4e74c2d6e0f8eaa690992a3ce42a9d9f6a584bc23d0"
    sha256 cellar: :any,                 monterey:       "9fbfa45ba702cd0a6a165be73bc5d69f87223683265ce4f6b0f8fe13041cbd5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac3bfd4c526d7ebe707ad4d3969c840a837ab01555055c6b88a5558d1933fa4"
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
