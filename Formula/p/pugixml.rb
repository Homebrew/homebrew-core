class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.14/pugixml-1.14.tar.gz"
  sha256 "2f10e276870c64b1db6809050a75e11a897a8d7456c4be5c6b2e35a11168a015"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0f41be0efe77882d6d0b65ca703a788027b71142b89ddbe434ac39eb8a5c2366"
    sha256 cellar: :any,                 arm64_sonoma:   "84389a39deb0147cc58ace55574299b2bc0099a405c637aa19d8dd4c511527f8"
    sha256 cellar: :any,                 arm64_ventura:  "3e5ca11c38b02bc82571af1765c645852d73947047b40b4bba62d3cc64e26367"
    sha256 cellar: :any,                 arm64_monterey: "d0508642948a557dfe8b0ea0c764d350175e43730b3012ca1996ef3764aa4c4f"
    sha256 cellar: :any,                 sonoma:         "2b7b7969056aeda0acd1fbe6499c6552f40dd58bbddfbbeddfcdb6fd27a96ce9"
    sha256 cellar: :any,                 ventura:        "c66d3487911d7ad924b9fd13fbadf4eba2b1e94e723b2cde4275393d20ab97cd"
    sha256 cellar: :any,                 monterey:       "462e7ae6c93f462a714329abbf4b90256afa45601fad0783fdffb55706a05a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9816719d30fbd99d13f8bb883699ac4e3b640572e55bf57b9ce04b45ebda7629"
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
