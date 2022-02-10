class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.12/pugixml-1.12.tar.gz"
  sha256 "fd6922a4448ec2f3eb9db415d10a49660e5d84ce20ce66b8a07e72ffc84270a7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1058e0344bc06b6f527be38a98df08f6324faefd0c0460e37178a8b352e75b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00eb54391dc64a7acd061b4dc579df1b8705acf44e764c1068c2ce64499c6f3b"
    sha256 cellar: :any_skip_relocation, monterey:       "71c19cd9aa12465109f6554caab1029f313c875fd4e289fc58711f18a0507b2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f031dc613170692049dcb683b8d264c2d9570b6ae064c3171e7ad773a10fecb"
    sha256 cellar: :any_skip_relocation, catalina:       "f3c1292023222567b181efc6786f534a8ba93e848217df3ce6149ef465ab8919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508376120cbb612d741b666fbf96ac99cdc99d7dcea20120ac01f0085acf14ec"
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
