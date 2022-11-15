class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.2.tar.gz"
  sha256 "e8ef71236ac0d97f12d553ec1ffc5b6375d57b5f0b860c7447dd69b6ed1072db"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfb84f99cd8417948358145e0172ed7ad697d2e77ca4e21beee4463d8351b0e2"
    sha256 cellar: :any,                 arm64_monterey: "cdc23066920bb62986f4b848b4ff6b13cdd8c211f5b6b6f3dc0ce739ff248bbd"
    sha256 cellar: :any,                 arm64_big_sur:  "209c3641472a9688d92f6cf2557dbb3c004e9c2e83b995eef0bf1d4fb259a476"
    sha256 cellar: :any,                 ventura:        "01abac2200f8d03f6b9eb3fb7d940ce085dcf23633e4d8c384439f25a2c68f8d"
    sha256 cellar: :any,                 monterey:       "6f5347f6bb7a69ca3ec3655806d173db4219ff28f880d561e16654379a1dc615"
    sha256 cellar: :any,                 big_sur:        "189cb36dbe972c0ad1b9ddfb770b2223ff04ee44eaf72d6359e522bd14c956a8"
    sha256 cellar: :any,                 catalina:       "6a301cbf286cef4498342aa45f1beee434f557cfb1bc5f27657b45125f4124e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffafceae65875313337f7f094ada2abe73a49520520ac078ab4f2555714e4011"
  end

  depends_on "cmake" => :build

  # These used to be bundled with `jpeg-xl`.
  link_overwrite "include/hwy/*", "lib/pkgconfig/libhwy*"

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHWY_ENABLE_TESTS=OFF",
                    "-DHWY_ENABLE_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
    (share/"hwy").install "hwy/examples"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{share}", "-I#{include}",
                    share/"hwy/examples/benchmark.cc", "-L#{lib}", "-lhwy"
    system "./a.out"
  end
end
