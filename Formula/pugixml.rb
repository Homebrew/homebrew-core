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
    sha256 cellar: :any,                 arm64_monterey: "a5284ea4e8d6fa76cd41505294e23a4c448b54d888de993b3cf57308ccbb5cd7"
    sha256 cellar: :any,                 arm64_big_sur:  "72487f35e935099779ea88bbbf6dd205406710df262674e6295972edff2a9ac1"
    sha256 cellar: :any,                 monterey:       "83d019d9a46aaa30c40a9acbebfeb19115b09f8534262a8d5ef156bdaa0c3e0b"
    sha256 cellar: :any,                 big_sur:        "450e11f4eafe21828d3987620406eb42695a60c15086b7741898d483bb05fa8d"
    sha256 cellar: :any,                 catalina:       "112dda2780766cf7403426252180cea172cd396f7b52aee42a690aa7539c933b"
    sha256 cellar: :any,                 mojave:         "60d558fea876933be7a5322267ca58c0850eb23ec05d71b3d2c3876793b01367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6e3c671984d4a3c53e58f79ecf45be27b3c57d1073223aa2c0c4dde91aa80e"
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
