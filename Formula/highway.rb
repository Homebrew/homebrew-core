class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.4.tar.gz"
  sha256 "faccd343935c9e98afd1016e9d20e0b8b89d908508d1af958496f8c2d3004ac2"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bf339bb1c48a86e1184b779e43a014e7a225bbc39d35fde53ca8dc4cdf41d117"
    sha256 cellar: :any,                 arm64_monterey: "25a7c5e9e1efccd83c720528bdb2ae1f95b717b6e0c831aaec3f1aa5fd52336b"
    sha256 cellar: :any,                 arm64_big_sur:  "c84a4071052cad3f05d4ffc48a4bb465d28a67e758dd6014489f7ce5492ce271"
    sha256 cellar: :any,                 ventura:        "3b0a131e0e508ed7e82573b2533cc805683505978634e4d9dad2589b252ce57d"
    sha256 cellar: :any,                 monterey:       "d6d822c9109e1e382593ee54a7d59146c63ce153008f56740068f98ecbab2e3c"
    sha256 cellar: :any,                 big_sur:        "9c3214e645ed27aa0c3de5f15b1675f06bbaed2f4019427153ea17c7e524ff34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "013c196452d1498bb642756ccad877df568746e0dcaa7b3f0e334fd3521df27e"
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
