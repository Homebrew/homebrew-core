class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.12.1/pugixml-1.12.1.tar.gz"
  sha256 "dcf671a919cc4051210f08ffd3edf9e4247f79ad583c61577a13ee93af33afc7"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19e760a6589f9d8359754ee3a6bb1bb1b916df570d52299299eb2d7b98868697"
    sha256 cellar: :any,                 arm64_big_sur:  "44de01d90730246427618bb49d3069ca3b4a3965f458036cf8f789d1e021fd78"
    sha256 cellar: :any,                 monterey:       "589881fa373d36a21c84c4c42f6175ef7ae1918f5c7a037386695dca054a9005"
    sha256 cellar: :any,                 big_sur:        "48f559efb06c1d60d553db9273141247018ee7aa68ab37679de9c09a999a6d1f"
    sha256 cellar: :any,                 catalina:       "a925fd3a353e10226a70e6695f69210a5f117ab8b7c8a8f98970fa59fbfa2654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9efcb2f9e87b4a51fee55123c9900d332c6f3c9c3fce67eed2d55f19becadb9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPUGIXML_BUILD_SHARED_AND_STATIC_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
