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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7413361442c9abad17da7d95698553b64f32218d45bfbfb25c0eccbadc64b3d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8bcaab7ffa6bc363b3ee06bc27d93512d86fb3b805fd52b15f2cf22850d4c0"
    sha256 cellar: :any_skip_relocation, monterey:       "9a053f8669cb6a274c35bbd2c3c070a8d42d68e7f25f870cc49344b15cc1f06f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea310c8f98a257ef09cd30c6dcd7e811b198b8612e277151a312d9b8c3554842"
    sha256 cellar: :any_skip_relocation, catalina:       "7a047ad63c666fabf1c3a65b7e3d9d6f5156dba4e663f0fa37c13e6ba3fb4517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad31c8f9950b70f43cc6f28ebaae6c9ce755a5c65c2fd1aab52707a8329bca1a"
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
