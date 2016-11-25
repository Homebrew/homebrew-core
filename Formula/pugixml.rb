class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "http://pugixml.org"
  url "https://github.com/zeux/pugixml/releases/download/v1.8/pugixml-1.8.tar.gz"
  sha256 "8ef26a51c670fbe79a71e9af94df4884d5a4b00a2db38a0608a87c14113b2904"

  bottle do
    cellar :any_skip_relocation
    sha256 "03ed2cba1e134f863836877d8a328ec9a3a65097c9815618adef6e8fb26c501d" => :sierra
    sha256 "c21e9b8750463c6b5e232c40e695095327fc8afe855d8b8e149d4ea0eccc204d" => :el_capitan
    sha256 "400c5afde63177b4a7c40d665a3a052d1e10ddfdc69c5d5ee97c2542fc1117b5" => :yosemite
    sha256 "6d0abed138bda13d447f4f800f4d0154efb5d34315bbe6f2d49193bac410409c" => :mavericks
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
