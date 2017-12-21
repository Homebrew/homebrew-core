class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.8.4.tar.gz"
  sha256 "c49deac9e0933bcb7044f08516861a2d560988540b23de2ac1ad443b219afdb6"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "c573df8afc8f128197fe604dd13b6566e7136aa034d82b634e5ca4414132e212" => :high_sierra
    sha256 "c83393c07b4a1d3a34b73549d53885baf000724055959c6e1ed3d3843d404f5a" => :sierra
    sha256 "5ce443c585742b356a818f408a5ca2cddb309d1fa0beaedcc4c4f3259016c39e" => :el_capitan
    sha256 "be145cf78eb4baff4cb2aa29963ec1c955202cb936d736db2536ec0b06a48e23" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args,
                         "-DBUILD_STATIC_LIBS=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DJSONCPP_WITH_CMAKE_PACKAGE=ON",
                         "-DJSONCPP_WITH_TESTS=OFF",
                         "-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF",
                         "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json/json.h>
      int main() {
        Json::Value root;
        Json::Reader reader;
        return reader.parse("[1, 2, 3]", root) ? 0: 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
