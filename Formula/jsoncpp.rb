class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.0.tar.gz"
  sha256 "bdd3ba9ed1f110b3eb57474d9094e90ab239b93b4803b4f9b1722c281e85a4ac"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "8d6ea20868bdc6413885decdf8aea1650bf75b6b7241087971c1eb9bf3b6fb14" => :mojave
    sha256 "bf4d4348fcb4190064473bbe40885339ccdcdb28c2ffc4f01942f770d754c320" => :high_sierra
    sha256 "f5ccbb17eb6a6595a531443776ec1d29d739dbe7cb84425c9faf1c1b8ad713e7" => :sierra
  end

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
          Json::CharReaderBuilder builder;
          std::string errs;
          std::istringstream stream1;
          stream1.str("[1, 2, 3]");
          return Json::parseFromStream(builder, stream1, &root, &errs) ? 0: 1;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
