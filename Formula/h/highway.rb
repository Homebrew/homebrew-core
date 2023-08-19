class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.6.tar.gz"
  sha256 "d89664a045a41d822146e787bceeefbf648cc228ce354f347b18f2b419e57207"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a38d434438a7796911d318b8508855c8a2002437c6e0fb41caf40504a912192"
    sha256 cellar: :any,                 arm64_monterey: "a45c755d16d2b0a471dfa6d537a93b7e210d7f5a9cedc7a16ed536ba88c16e5b"
    sha256 cellar: :any,                 arm64_big_sur:  "a8c510a558d8a12d584416f1258bd8f72dd6228ee6bbec0487d5bf0aabc2c692"
    sha256 cellar: :any,                 ventura:        "0319016ec210c2a77fa10e75f25f34420925dccc8819f81d622d13eace7194b9"
    sha256 cellar: :any,                 monterey:       "7b32dac3298fbaf576db43b560690d540b232e19377398512a0ac58cde37f4c2"
    sha256 cellar: :any,                 big_sur:        "ea7e37c4cf96e99ae53ba1e598833281e9d15b56ba25417b9465cf16df5fc6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9612fab636e5735798f8fb564e1c42b2485a5291f66d26271b75867f786c1fd2"
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
