class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.9/pugixml-1.9.tar.gz"
  sha256 "d156d35b83f680e40fd6412c4455fdd03544339779134617b9b28d19e11fdba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "18c71dfca0583f9896fe1215b90772d6619f698c5e432bdab5a1afdf75c901af" => :mojave
    sha256 "53ad542db23961c7ed6e7e7e6974c54198823ddce6644ae172d1f798136a0218" => :high_sierra
    sha256 "879ed1d86051a4230499b368e2a8d7b9ebcf5792ff0dd40aa711b311426bf6e1" => :sierra
    sha256 "a8fe6aafdb9826497121f3b616f382a7447a04dc252770b0828de1e4b4c99b99" => :el_capitan
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

    system ENV.cc, "test.cpp", "-o", "test", "-lstdc++",
                               "-L#{Dir["#{lib}/pug*"].first}", "-lpugixml",
                               "-I#{include.children.first}"
    system "./test"
  end
end
