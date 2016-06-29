class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.7.3.tar.gz"
  sha256 "1cfcad14054039ba97c22531888796cb9369e6353f257aacaad34fda956ada53"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "f8b8e75756d1bb9b0a9d88fe7269db4606dcc35a3b4c48fe067e4ea7d63f54b1" => :el_capitan
    sha256 "2843ed952aaad544b622a1661afb1f2212209e06aa1e8c89745f2b8f5c0f9641" => :yosemite
    sha256 "922249599c923f247b316ecad8cf75acd174ba9c78d9accfe21d26ebf3de9a8c" => :mavericks
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
