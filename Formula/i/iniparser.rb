class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.4/iniparser-v4.2.4.tar.bz2"
  sha256 "767963cff69aa7b0c7e48b74954886d5e498835056727fce25aecb19ff551d43"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0c73018cec15ab4fe46af32c13a436c6c1cd0af280351aca183c4381692cf3d9"
    sha256 cellar: :any,                 arm64_sonoma:   "4716c32b4218b5094b0a19479b1e8b65cd94dc04a40bf41b40799dd243191abb"
    sha256 cellar: :any,                 arm64_ventura:  "a3c4368ddedd5810ef7db6e6a2d704d3d5a4fadff279bcabd32e5362144f2f01"
    sha256 cellar: :any,                 arm64_monterey: "21e6754ad6276fd4ece5ea82b85c5fffe8f110d47892fbce03ad85e6b27cf83d"
    sha256 cellar: :any,                 sonoma:         "301b365695b0e63861f07840b57804de9ff2d5b58991fb6abcf5fcad48d56c23"
    sha256 cellar: :any,                 ventura:        "915fab6620a440294d3a357053e2f23d7cb3709e1fc5c2950acc0d976442d187"
    sha256 cellar: :any,                 monterey:       "db5b501e6789c181018def30a06c00968be958b6e41c87ccdc15c451e1e66216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969c5952f004e0c00e5b845c76d7c060c023028c0d6a39b0bc87faf038db3308"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

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

    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-liniparser"
    assert_equal "Parsed value: value", shell_output("./test")
  end
end
