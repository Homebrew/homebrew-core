class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.3.0.tar.gz"
  sha256 "07b3c1ba2c1096878a85a31a5b9b3757427af963b1141ca904db2f9f4afe0bc2"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "05e894730e54a6fad0d82afc54683f1b0adb57030df6267b9bc5b9158fbdc8eb"
    sha256 cellar: :any,                 arm64_sequoia: "0dfc837e61d17b1cd2c5e27afc94993a4eb75b59ca8a057ef7c6dea61acbdd7a"
    sha256 cellar: :any,                 arm64_sonoma:  "2f9c0e4c9aff6efe166b35fd6ddc8d1caa136f3bdcc50ab8aa96119ab72874aa"
    sha256 cellar: :any,                 arm64_ventura: "b6e9d5855fedf4203e7856273243216006891456a0eef39fe76d49e54644fc30"
    sha256 cellar: :any,                 sonoma:        "da1f77ecabc34ef77c51fc88b93822d97c71a2194e01718dbb0b022adcc65f18"
    sha256 cellar: :any,                 ventura:       "570a43c0431fb340fec123e7e4b84fcc57ac3119520abc04837d33fdf66b2746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4608e3689ddc33b32d0328c2618eaafa332985bbea7ef32b211c680a15990be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e2f815b1622ec617780ff5b796c16c97dbe0b7e148f428d329f49a9ec6bc72f"
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
