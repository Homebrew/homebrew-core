class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.11.4/pugixml-1.11.4.tar.gz"
  sha256 "8ddf57b65fb860416979a3f0640c2ad45ddddbbafa82508ef0a0af3ce7061716"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "b5907655e8cc2b492a94bf16429dc8f5bc291a6026bc66efc741cec5a7330878" => :big_sur
    sha256 "2686199eb313f6e0dd1fabe17dad72e2887db87a91ece9a9941f985e6b708379" => :arm64_big_sur
    sha256 "11822d841b3a4a1542078155e2f09ff78b06ae6cb486e0589296b1385dbf8269" => :catalina
    sha256 "7980b0950e3aca862900ab1b167ce8ec5cfd41ceceddf43e52caa464640dc9c7" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_AND_STATIC_LIBS=ON",
                         "-DBUILD_PKGCONFIG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <root>Hello world!</root>
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lpugixml"
    system "./test"
  end
end
