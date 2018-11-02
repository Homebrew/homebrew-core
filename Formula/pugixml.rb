class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.9/pugixml-1.9.tar.gz"
  sha256 "d156d35b83f680e40fd6412c4455fdd03544339779134617b9b28d19e11fdba6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "65415981e37fc57d6e01ccd5ce9ef3a28f0b127ebefad23978a826fbf90ce6c1" => :mojave
    sha256 "88887f5773727df5b02405326b57821c7d8ae625bc36878d5abc9317e66a9f74" => :high_sierra
    sha256 "349e189771d80c798d920be6ff8f6d24612528a05e4285c4957e806092792604" => :sierra
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
