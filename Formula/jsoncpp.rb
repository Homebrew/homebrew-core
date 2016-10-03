class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz"
  sha256 "087640ebcf7fbcfe8e2717a0b9528fff89c52fcf69fa2a18cc2b538008098f97"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "0666826b27287092e0678fe5753cf112800308a197b489db50008f3452fd5081" => :sierra
    sha256 "3e256d37a552adf2f84ccc5f2800489816fbba196998f7d510c0a39fc17a520d" => :el_capitan
    sha256 "c52d03c2ffafdd66719e14dca20892b6bde4d918fcd28217f1ebc9f9b721c34b" => :yosemite
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
