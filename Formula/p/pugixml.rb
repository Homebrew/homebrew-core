class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.15/pugixml-1.15.tar.gz"
  sha256 "655ade57fa703fb421c2eb9a0113b5064bddb145d415dd1f88c79353d90d511a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "815d949fe34679a2c3e0df5d253b824ebe69305ae29ce28d03e4e2cd604ce46c"
    sha256 cellar: :any,                 arm64_sequoia: "1d3349e3cf6dc0d06fffd2c52c62801b3c804e36cabcb01f46682738bb1485c2"
    sha256 cellar: :any,                 arm64_sonoma:  "d648b349479d6bd41c0ee2e22fb9108abb33a553c5ab21584564a6a36fac04c6"
    sha256 cellar: :any,                 arm64_ventura: "e6641fb533ddb45418980698aab6b06a02a3c5e763cae6ab7bb513289e5248d3"
    sha256 cellar: :any,                 sonoma:        "32cc92f8679e9a6d8b0c45140a19f0ac5c330e470bbca5cddcf494c6511beae6"
    sha256 cellar: :any,                 ventura:       "fc421bf66929e255b8a433eae74d0f32482ce73dea8b8da850f9f6efd1970a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd7825a7cb16dab42a7884e8626dc8d7380081f0e163517037e28bd5136491f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2578c1114075b488ec20a5c627d9616af5a6e5f22d9f99e54d0bb6221a861f77"
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
