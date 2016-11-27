class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "http://pugixml.org"
  url "https://github.com/zeux/pugixml/releases/download/v1.8.1/pugixml-1.8.1.tar.gz"
  sha256 "00d974a1308e85ca0677a981adc1b2855cb060923181053fb0abf4e2f37b8f39"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d574c83dbf98b5d622cc6256c8ef030b2e530db5ff72480fced675e6bfd0e84" => :sierra
    sha256 "3715391781ed243b597e50a8e66484a0b704e8f3b9d4f633a7ac430358314857" => :el_capitan
    sha256 "07956837628569f621359f07efde0b47efb4bb7d117972ba7b5e8d01ebbd40e5" => :yosemite
  end

  option "with-shared", "Build shared instead of static library"

  depends_on "cmake" => :build

  def install
    shared = (build.with? "shared") ? "ON" : "OFF"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=#{shared}",
                         "-DBUILD_PKGCONFIG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

    (testpath/"test.xml").write <<-EOS.undent
      <root>Hello world!</root>
    EOS

    system ENV.cc, "test.cpp", "-o", "test", "-lstdc++",
                               "-L#{Dir["#{lib}/pug*"].first}", "-lpugixml",
                               "-I#{include.children.first}"
    system "./test"
  end
end
