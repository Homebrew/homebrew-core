class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.3.tar.gz"
  sha256 "4b1f28e76020775334e67cc348ceb26a4f5161df6659848be0d3b300406400a3"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e2843d77a6e85e323f0304ce4e0bdcb2806b6f830a5f9d60c4268db4fcc623a"
    sha256 cellar: :any,                 arm64_ventura:  "7223045e0c81ba45f7c94517431011ac85771d5c27014a9c7e928be1f915cefc"
    sha256 cellar: :any,                 arm64_monterey: "331ec6acb3436b223a0d4ca94a437fc4a2b9a00af14b2e4b0a78ffc70e40354c"
    sha256 cellar: :any,                 sonoma:         "f0e7841ee8b9e5766737b27c08cd080315da60de26d455ca316b7636d0a59c1b"
    sha256 cellar: :any,                 ventura:        "ec6cae409f87d59a793eb780b4a9446fec2995c9999d665d6464d7565bac0adc"
    sha256 cellar: :any,                 monterey:       "975f75492f82471f41a042d2258c75a32e180fb9795e9c81fc1846cb83a41bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb85b3f8464539c0e294079964e8f92811e29f22e06cb840caaf86d966b9c4b0"
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
