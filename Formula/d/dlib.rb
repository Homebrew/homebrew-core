class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "https://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v20.0.tar.gz"
  sha256 "705749801c7896f5c19c253b6be639f4cef2c1831a9606955f01b600b3d86d80"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0e98ca135cecee556c669e44f3b6b7a536a6a1c27cb2dc76396665bf4139233"
    sha256 cellar: :any,                 arm64_sequoia: "7494ec3521c2c39b522ba30cab0a2e2d380c5222f31775f2bea98585ddea741f"
    sha256 cellar: :any,                 arm64_sonoma:  "b636c93546d2692d574ab5b3f7013f18ca3568cef1408938ccecd7306c49ef02"
    sha256 cellar: :any,                 arm64_ventura: "d246a77b6d001806652429c4680f717836788055a82a015a75232402eb90730c"
    sha256 cellar: :any,                 sonoma:        "959777d3009abe7fefed086c20bfa72dc5badd28cef86e35cf7ac1c910b0f550"
    sha256 cellar: :any,                 ventura:       "33dab9fb08341c856080b0c834145b10fc66347b1c9b28ea3387948d9fa47765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389aac4f5901a6c86112302d131c2df645bca1cb5001092bd946e8da2ac5d705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82c6dfb7fc2ebfdcfd6c1bf6b83445e9729621962cefa5ba608b810b54f9e014"
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
    (testpath/"test.cpp").write <<~CPP
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
