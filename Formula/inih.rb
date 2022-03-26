class Inih < Formula
  desc "Simple .INI file parser in C"
  homepage "https://github.com/benhoyt/inih"
  url "https://github.com/benhoyt/inih/archive/refs/tags/r55.tar.gz"
  sha256 "ba55f8ae2a8caf0653f30f48567241e14ea916acfc13481f502d8a9c8f507f68"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ebb6e242ad1b3edf6960c4650db959df095a1d7e4047ab0bfa6747d6fd1f0fc"
    sha256 cellar: :any,                 arm64_big_sur:  "c0f1ba13977cacda5b6e4a028d22e249e479fc295aba5ed7de36d14ebbcc5a3c"
    sha256 cellar: :any,                 monterey:       "0c9f810156a2ffd617512a53082db6e21c47c91d9185485de1e384838f9d376d"
    sha256 cellar: :any,                 big_sur:        "71b1efdf3603ab0cc218840f7ffd0678fa4fdf6187c92b3dbeb8fbba41484d3a"
    sha256 cellar: :any,                 catalina:       "e7d70a5291a18636ed73c3226f260069a63b09f77b2282d6a085a2048d310cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071eac9277f03b4c092f5b766fe38b6448fd50104bec4399b3358ba5759ea31c"
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
