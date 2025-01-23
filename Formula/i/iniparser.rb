class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://gitlab.com/iniparser/iniparser"
  url "https://gitlab.com/iniparser/iniparser/-/archive/v4.2.5/iniparser-v4.2.5.tar.bz2"
  sha256 "a4ad132a4a80a713c2f972c9f9262c5a307526e21eb547ecce274592a63946a3"
  license "MIT"
  head "https://gitlab.com/iniparser/iniparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c29fc7a34573f1b134acc127eae142cfaec24fbe7e6f4ca2f8823890e042cc27"
    sha256 cellar: :any,                 arm64_sonoma:  "6620efc68bed97e1d3fe5827e68ac1dbcc95d16324740ce6ad1b681a54531a69"
    sha256 cellar: :any,                 arm64_ventura: "b83cd2dc0b27c56ea3a6892e6419c710c8628be1511ecbdea59da3b2b83f3802"
    sha256 cellar: :any,                 sonoma:        "251bc97d7d6747300b652b605f6055f430eb0ad42411c6b3148ead7db41a7019"
    sha256 cellar: :any,                 ventura:       "5a006e2512a255257c5d3ba620d1303635a661406b752d2bd894b8dc93220484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98af185fa0d6d137642948abe69914b267f777465fe2120e5089daf1db69a85c"
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
