class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.16/pugixml-1.16.tar.gz"
  sha256 "4cee1ca4aad395170f4c7a07824f3bdd41f28316c6e1e1090a1425b278ec0b4b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8de9b221f2d31147de65ccf2a91f088baf8f16198c916e704618c74f04b2d93c"
    sha256 cellar: :any, arm64_sequoia: "1483e3c7254de95b12568d9841f76c2d2324ddad5cc3902cd44facd14c751b66"
    sha256 cellar: :any, arm64_sonoma:  "0631c09780b23a8b5ed5fb14031680a34715319aa6efe5b9919964c8095eca54"
    sha256 cellar: :any, sonoma:        "2e2c27fa84a1103fe342398de9b3d8c92f2b39574ddfc2d21cf7f2308a0dc27d"
    sha256 cellar: :any, arm64_linux:   "5093fae4721a6e05f51ae71c4ffe7b88c09a942cb38834560f98e7494e247401"
    sha256 cellar: :any, x86_64_linux:  "856f8e8c6388191cdb0afa8d126e396c40bcb8870c3645ffa5eb965ff444dc98"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPUGIXML_BUILD_SHARED_AND_STATIC_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    CPP

    (testpath/"test.xml").write <<~XML
      <root>Hello world!</root>
    XML

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lpugixml"
    system "./test"
  end
end
