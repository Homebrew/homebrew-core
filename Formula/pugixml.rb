class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.11.1/pugixml-1.11.1.tar.gz"
  sha256 "9dce9f0a3756c5ab84ab7466c99972d030021d81d674f5d38b9e30e9a3ec4922"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6467a14e11171c7c01d1c2188afe4c0563d2a4332538f430995ed16fe52c3fc7" => :big_sur
    sha256 "fa4b6e0c3e5b9f446c2c48e9802cfcd0e66822fc3e1bdd76fe4b3555446dda15" => :catalina
    sha256 "ddb195caceb2c0eed78941b9fc8c525df45f6e615b48d9d378c02be7df5a2c7d" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF",
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
