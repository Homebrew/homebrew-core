class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.8.1.tar.gz"
  sha256 "858db2faf348f89fdf1062bd3e79256772e897e7f17df73e0624edf004f2f9ac"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "979f26dae212b696ea1f0fe37e022e07ef1d9c6e5a300abe66e79ded804eb6bf" => :sierra
    sha256 "b418b5afee4f4decd68291e2a17b5a6a3583c9c97fb66c57bb5b4fb3c573c802" => :el_capitan
    sha256 "9f33d38dc6d459622705c4982204e0eea49a5d9a14440a032695dd1b72214cad" => :yosemite
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
