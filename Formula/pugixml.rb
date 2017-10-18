class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.8.1/pugixml-1.8.1.tar.gz"
  sha256 "00d974a1308e85ca0677a981adc1b2855cb060923181053fb0abf4e2f37b8f39"

  bottle do
    cellar :any_skip_relocation
    sha256 "88279a4b4b301a1ded43cd30cb681d1b3f00b2be978449eec000f7828e5e6a6f" => :high_sierra
    sha256 "4424c7e5154752886226e91bc8bd7a404079062d0705816533b1a86181fa95d6" => :sierra
    sha256 "13495a332f3e2ba56148b936d42034d55373ade74af0c41f0c77feb52038ea43" => :el_capitan
    sha256 "b2b7594b9fb20bda5ed45324ef815af60617673d6f86e066fbd988a8f82a0c16" => :yosemite
  end

  option "with-shared", "Build shared instead of static library"

  depends_on "cmake" => :build

  def install
    shared = build.with?("shared") ? "ON" : "OFF"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=#{shared}",
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
