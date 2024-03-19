class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.2.tar.gz"
  sha256 "0f5c7e3de6316a513635052c5f0a16a84e1cef26a7d233bf00c21348462b6d6f"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f382c1f7935c4bcd5000bf77e4b96571798713e7adc45c131b5cd53386e6e6d0"
    sha256 cellar: :any,                 arm64_ventura:  "09dac41cac342b4057f1e0422fe810d6eb92cd07970ac97c221b17fe836c12a7"
    sha256 cellar: :any,                 arm64_monterey: "426349c468344255a1f03a63a5d707b83f8837c44e35b46920cca3b7fbaaa2e5"
    sha256 cellar: :any,                 sonoma:         "57059294f7ca3a47e5055ab12b0cbc67ca842832f88609ec8d2d375bcedf73f3"
    sha256 cellar: :any,                 ventura:        "17e51002247200dcd930d7d3677e92eb71538aac1f4afc446ac3a12bd7f680a3"
    sha256 cellar: :any,                 monterey:       "0f6ad77f551f870b05c6669e3b987f35dec7c4cd51564697e771d146d37bb7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14de2a87642ed886204d1548944a726b72f6df827199996f22f8548b1afa122e"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if OS.mac? && MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
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
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
