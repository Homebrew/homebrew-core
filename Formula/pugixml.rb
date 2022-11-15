class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.13/pugixml-1.13.tar.gz"
  sha256 "40c0b3914ec131485640fa57e55bf1136446026b41db91c1bef678186a12abbe"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8342cbe96ddcb6316547c3e153988ebbe8df9377e3d7e40f596862606231a2f1"
    sha256 cellar: :any,                 arm64_monterey: "00b008f8d19c4d9f9c2ab610978622cd356958da8ad37dbf7295b6e05e2aae03"
    sha256 cellar: :any,                 arm64_big_sur:  "40f7fed3e7b4f7ebd33d7909c7db5513ae64b5476329ea598bfaf93f95740e13"
    sha256 cellar: :any,                 ventura:        "5223925a625c1e3f6a2c8bb229ebae09b95c3c26a3f08132e6c905c416833efd"
    sha256 cellar: :any,                 monterey:       "c394eed7f1a3076d2e52d8e4cd4adc008f3456cf94234bbea761c32997bf7fdc"
    sha256 cellar: :any,                 big_sur:        "0267ec889e6b5699a0c98619c3c5d88cbac35b92cf053b9ed9935b134853d441"
    sha256 cellar: :any,                 catalina:       "1830a4ad92d8991fd85590414f710c11f8ab4a760537f00ad24e6b7623fc7ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d0c2c12331bf2c09d4e96c83bd1fab2cbac2637e2f3aad28f6e33682bf73b33"
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
