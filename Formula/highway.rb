class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.1.tar.gz"
  sha256 "7ca6af7dc2e3e054de9e17b9dfd88609a7fd202812b1c216f43cc41647c97311"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "301fe3b3ffb3875b47ef48cc80f1f6ec2796ba648fe9c5785501c577eb784a80"
    sha256 cellar: :any,                 arm64_big_sur:  "ab6cc22dcd2b1baf85a8fb6bb6f67e098087a6e02e72c3b8c3dbdd446ce63176"
    sha256 cellar: :any,                 monterey:       "0a64c83377262ac734da3001b4d2bba1dcac60fb7ec8fab2e3a68f28cff46de0"
    sha256 cellar: :any,                 big_sur:        "0c9e42c9c4f7ee57aee7ad16ecd8976b59c3bdff0a41c3b21a141955b04ba994"
    sha256 cellar: :any,                 catalina:       "0ff04ecf1b79966e71936d7eed1ddab6a563b290dd0ffdf3ead6e6bcb6fd7c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f76843e127c89e5da439264ee292103846991c720bd63070cebbed132125164"
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
