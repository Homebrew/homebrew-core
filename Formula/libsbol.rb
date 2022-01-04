class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98d0945d4d7e7fd37d5e71cde652b92f7b4a3b80164ae46fe50cd2cfabad160a"
    sha256 cellar: :any,                 arm64_big_sur:  "5148eefde20cfafb8945cb75b362f6c88e5a856093da176db7b1feb45afe4354"
    sha256 cellar: :any,                 monterey:       "d5be309a865acfe2c770539c27c669808be6f914165d0c525aa1d9e0e4b8fd29"
    sha256 cellar: :any,                 big_sur:        "106cf40dc3cc5f552ad256cead869e6bf80654d8cb8764189691399a88168b7a"
    sha256 cellar: :any,                 catalina:       "69d13417a5f365bda9b5da5097f0b253fc76a9c237ac733ef7b684db1a3e01d6"
    sha256 cellar: :any,                 mojave:         "2d81b55c1e379756aaf37667757273a6581ee98083ac6b87c0d2392020249b19"
    sha256 cellar: :any,                 high_sierra:    "cc6aca556487165bf44a40d159428652cae3b60e04f685281a5662b5ced42d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f787e31668d8d609cdf74155c6ce665711cd6fa0dab5374b9583086ca2e0001"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "raptor"
  depends_on "rasqal"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    # upstream issue: https://github.com/SynBioDex/libSBOL/issues/215
    inreplace "source/CMakeLists.txt", "measure.h", "measurement.h"

    args = std_cmake_args
    args << "-DSBOL_BUILD_SHARED=TRUE"
    args << "-DRAPTOR_INCLUDE_DIR=#{Formula["raptor"].opt_include}/raptor2"
    args << "-DRASQAL_INCLUDE_DIR=#{Formula["rasqal"].opt_include}"

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      args << "-DCURL_LIBRARY=#{sdk}/usr/lib/libcurl.tbd"
      args << "-DLIBXSLT_INCLUDE_DIR=#{sdk}/usr/include/"
      args << "-DLIBXSLT_LIBRARIES=#{sdk}/usr/lib/libxslt.tbd"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11",
                    "-I/System/Library/Frameworks/Python.framework/Headers",
                    "-I#{Formula["raptor"].opt_include}/raptor2",
                    "-I#{include}", "-L#{lib}",
                    "-L#{Formula["jsoncpp"].opt_lib}",
                    "-L#{Formula["raptor"].opt_lib}",
                    "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    system "./test"
  end
end
