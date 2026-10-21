class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.3.2/iniparser-v4.3.2.tar.bz2"
  sha256 "60fbba5c2f6c2aa3856c3ba1b6674e48f3322e3437228e5e7df7a0f222e52ac7"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1591a9725ea441182807bd5a0a5b125e7e84b8f0919b2f5846b0dd81dba9be82"
    sha256 cellar: :any, arm64_tahoe:       "8830552f5c82db87a882efff61ee7fdddfe3bf6b31b5129377356327710bf9bf"
    sha256 cellar: :any, arm64_sequoia:     "a4b78540d02064d07483df6b30a6b0d6ff370449c991e5a2e46f6fe88ce3c49b"
    sha256 cellar: :any, arm64_linux:       "17aff49714e7643f8178122d4e38c751e5280a3a0185b86c3bc042e6bb8a6a15"
    sha256 cellar: :any, x86_64_linux:      "9c67785e4c9c19dff138baf9168b42c5afe014aae56db48e5c68ed57e6828635"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
