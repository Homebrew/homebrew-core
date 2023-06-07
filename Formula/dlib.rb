class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.24.tar.bz2"
  sha256 "28fdd1490c4d0bb73bd65dad64782dd55c23ea00647f5654d2227b7d30b784c4"
  license "BSL-1.0"
  revision 1
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?dlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72d97fda7f1615c971e268477e67f8ca5969fa2a98a368fbd0d28bc762991864"
    sha256 cellar: :any,                 arm64_monterey: "20350a3f0a638a1a5b6466c4809c7beea386545b35a98de7181bc66e2d3a0e3d"
    sha256 cellar: :any,                 arm64_big_sur:  "2546c7c03817f1181c406a1e6167c2a66a0a87b224567b7a7feb7c4111736e39"
    sha256 cellar: :any,                 ventura:        "86647e13b66b5aa7285c47144c30ca79075583a97805c1409e11366ae4592ab7"
    sha256 cellar: :any,                 monterey:       "3be4dd9f52d3d4aa041c1909159466b57f4ccbbb32404f3a07325d37d0fd8144"
    sha256 cellar: :any,                 big_sur:        "2d16a7080c79a77d00003641420e051dd08a69f6b1f2233af47afd76de567909"
    sha256 cellar: :any,                 catalina:       "d52920f7bb619e287c2eb05e902ca4041d6dc08344e48d75b6ad7575e0d27774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d95e3ef4dce0839979479f9d75e24a6776f74d04f7f3a6f0ec9b365e7e81392"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    EOS
    system ENV.cxx, "-pthread", "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
