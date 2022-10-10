class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.1.tar.gz"
  sha256 "7ca6af7dc2e3e054de9e17b9dfd88609a7fd202812b1c216f43cc41647c97311"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3cdf11ce370958e7ab8a632f72f2314f158ad11589530039761dacd0cfb38c73"
    sha256 cellar: :any,                 arm64_big_sur:  "5b75f29e2d9696b39705face1c606f373f71695492b5027454e32196206198d0"
    sha256 cellar: :any,                 monterey:       "5e8cf8ae1bd0a2d1f87a58c70522fd6f5ce0a411acbe4be141a74fca21fdce25"
    sha256 cellar: :any,                 big_sur:        "bf41f04b4711c00fe930bf6ed4ce3f269d70ae9b732609aa3dc7bf246abe32cf"
    sha256 cellar: :any,                 catalina:       "5400bcc779804a0e2a4e8a5d4653bcd68a478f5d1f0129ed72c0bc5e7d31e991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c99eda57fca375f1e94eda95d3892d2a8a47cf2c0c47cb8526cc805f650e9d"
  end

  depends_on "cmake" => :build

  # These used to be bundled with `jpeg-xl`.
  link_overwrite "include/hwy/*", "lib/pkgconfig/libhwy*"

  # Fix missing missing exec_prefix variable in libhwy_test.pc.
  # Remove with the next release.
  patch do
    url "https://github.com/google/highway/commit/357e21beabb1af037f20130b4195fa5d0e6bbbfb.patch?full_index=1"
    sha256 "35ae4d7cd0cdaaca83c5b6da01b9c19f34c3f293b6892f3c3afdb202255f523a"
  end

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
