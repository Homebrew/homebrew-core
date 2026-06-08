class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.6/iniparser-v4.2.6.tar.bz2"
  sha256 "30f8eaf74b8c4667f2adef4c6b5c50699d1fa6e3ad65b65b0993d414d7ee3118"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c24a218c75b86e95755d3a109306cbdf98f7feef35fd39b4ef899eceef05c91"
    sha256 cellar: :any,                 arm64_sequoia: "5aab8ec466dbb3974f8dd4f365ea8d514801ee1832ef60309186b3769f0035ef"
    sha256 cellar: :any,                 arm64_sonoma:  "7fd0032d365acd032de46252eefaf99668c70c44ae9f23cfe93ffe8325b67556"
    sha256 cellar: :any,                 arm64_ventura: "317b964fca741f0cc3a16e607c4d992ea0a4dfd60a68868a05aba5ed84bc17fe"
    sha256 cellar: :any,                 sonoma:        "754b6ca8d166e289fa6a6510a576c6dbea76f0136c3fe82a3423002892be8aa0"
    sha256 cellar: :any,                 ventura:       "220c994a2c80e0b4ad4cfb281537500c5acb6172f1ab28db090341c9a2ad3dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89ed8749f1748dd06b6e4025b5b5c4c7b811b53e580e218d4089a61bba4d2082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4194648453a37551214cebaac99d63a204422271f2a298ed47f8e69a0d50a2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

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
