class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.10/pugixml-1.10.tar.gz"
  sha256 "55f399fbb470942410d348584dc953bcaec926415d3462f471ef350f29b5870a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffcc56b93b63ac573480cdcafd859bdee76409e834e4e6b855c0ac4cfa9eb94c" => :catalina
    sha256 "ee86188a54388e0644fd3f90e0319c8c734fb6ae254b23da609af17e1f579c9a" => :mojave
    sha256 "2b5ce73035deb5e9557fca05fc6100c4a1c18acf33816316185d00d9bb2198fe" => :high_sierra
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
