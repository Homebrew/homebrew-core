class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.11.3/pugixml-1.11.3.tar.gz"
  sha256 "aa2a4b8a8907c01c914da06f3a8630d838275c75d1d5ea03ab48307fd1913a6d"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5c2a0594b325ba7a199c1a855905fa7e3c2e7993eaeaf14bbbb929ddcb2b42cd" => :big_sur
    sha256 "7ce6497d0653fbcdca776a9e4804e25583b218329dd209a8d76b2d7020e7b3ea" => :catalina
    sha256 "1b482898c331dbfb80f9b98c935805b5d2380cea2b84cd3f1d74faa664686e1f" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
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
