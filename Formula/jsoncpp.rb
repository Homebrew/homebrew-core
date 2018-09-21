class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.8.4.tar.gz"
  sha256 "c49deac9e0933bcb7044f08516861a2d560988540b23de2ac1ad443b219afdb6"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "0bf833c715e66967808c601fa1566c25175fadd1d12715c2e72ccd3eac699337" => :mojave
    sha256 "107e81382b6927dd4310a5accef1c2fb48ad616a8a8f838ba31d20d4ce855a2a" => :high_sierra
    sha256 "9d15d02676d08bbcd0352f1aef7bba03206438aa50c5ed86358f45e9ef1534bf" => :sierra
    sha256 "ea9882112cc77b4500803dfb5043c846de7dc9d584f007978d05863f6a8611cb" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

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
