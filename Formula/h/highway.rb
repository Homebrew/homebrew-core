class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.1.0.tar.gz"
  sha256 "354a8b4539b588e70b98ec70844273e3f2741302c4c377bcc4e81b3d1866f7c9"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01a9e369d40dc0661fa3dcdd2dad2492432c8a30f22b29ad7bf7e43eef5a6a0b"
    sha256 cellar: :any,                 arm64_ventura:  "8398b9b3100d4e33bd59b5f5e583296604422bd73e27f745840a51a99685147a"
    sha256 cellar: :any,                 arm64_monterey: "10f7f22edbe1ca6413505126fcf3a334ff80e261327dca2ca9ed16fa29525907"
    sha256 cellar: :any,                 sonoma:         "acfbb86e99de351fed207e920eb632c6920bc6b8a2ebbd2b91cc4f4b9dcdc61c"
    sha256 cellar: :any,                 ventura:        "359deb4c23e5131ae22798e22bae009b3e185aaca228c3ebd112683e42c99bd5"
    sha256 cellar: :any,                 monterey:       "f5cdeafe6fd7fd2fec63a31d5467265cb4251d62e4a1fcf28de8284e030dca45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd48aa39099c37542468521eb56cdb502705a903fb4842102a3f9f320594e5e9"
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
