class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.3.0/iniparser-v4.3.0.tar.bz2"
  sha256 "5516ed5ca9871531936af25764f3d3b4a8ed7d7d0ecfc314d23ba980450cc8d9"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "50db3f59d1200080fec2fdd366fe942ce9bc43fee12327925786ff5102f996bd"
    sha256 cellar: :any, arm64_tahoe:       "f6ca33ba6ede9f764aa7e9b5ea8c84de8b92112aed61d8051e5c8a282833623e"
    sha256 cellar: :any, arm64_sequoia:     "8ac82a569780c1fdc7adb374f5568807bfedbc9905a8cf1b9634e952824b2e26"
    sha256 cellar: :any, arm64_linux:       "09d200784f38acab6d6dd7c6f3bbb11e9b1d32ebafb5c5550b0fe4ccb6f182df"
    sha256 cellar: :any, x86_64_linux:      "35c3e075be57d654d1a8ab8fa786a0887f413428466e5189a668ff7c7c60f6c1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_config = testpath/"test.ini"
    test_config.write <<~EOS
      [section]
      key = value
    EOS

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <iniparser/iniparser.h>

      int main() {
        dictionary *ini;
        ini = iniparser_load("#{test_config}");
        const char *value = iniparser_getstring(ini, "section:key", NULL);
        if (value == NULL || strcmp(value, "value") != 0) {
          fprintf(stderr, "value not found or incorrect\\n");
          return 1;
        }
        printf("Parsed value: %s", value);
        iniparser_freedict(ini);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-liniparser"
    assert_equal "Parsed value: value", shell_output("./test")
  end
end
