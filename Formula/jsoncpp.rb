class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.8.2.tar.gz"
  sha256 "811f5aee20df2ef0868a73a976ec6f9aab61f4ca71c66eddf38094b2b3078eef"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "fd3d570190892782c4c9d2458a2024c423527496cbbe172e132c3fe155df6d51" => :sierra
    sha256 "d2ef078761cc79854cfe639d148fa2d92c1bc773a051ad63e9cf98417efea289" => :el_capitan
    sha256 "972e64cef87ad5fb25175512c93b811b4ab2951a88c918d98c09ba15bf236754" => :yosemite
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
                         "-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
