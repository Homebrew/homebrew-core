class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.7.6.tar.gz"
  sha256 "07cf5d4f184394ec0a9aa657dd4c13ea682c52a1ab4da2fb176cb2d5501101e8"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "3533ccc77f79d7a9da253004bdfa2ca381fdb8df0088888caa6ed89ead7f55e0" => :sierra
    sha256 "550124ad1dc43daa44425c9ab06f50a83cc6c9845ec1f2d9d06cbb680fa3aa73" => :el_capitan
    sha256 "6d021772ab9b0ff7590951ed26e83c6cbfe9839eb05b9753c476f07a6ff7ca8a" => :yosemite
    sha256 "cb6297d83e2898ae496f98450a05cb1c29b25b3ca7a1e35dfbb95837758acb81" => :mavericks
  end

  option :universal

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cmake_args = std_cmake_args + %W[
      -DBUILD_STATIC_LIBS=ON
      -DBUILD_SHARED_LIBS=ON
      -DJSONCPP_WITH_CMAKE_PACKAGE=ON
      -DJSONCPP_WITH_TESTS=OFF
      -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF
    ]
    if build.universal?
      ENV.universal_binary
      cmake_args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end
    system "cmake", ".", *cmake_args
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
