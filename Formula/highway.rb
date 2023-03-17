class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.4.tar.gz"
  sha256 "faccd343935c9e98afd1016e9d20e0b8b89d908508d1af958496f8c2d3004ac2"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0df1dfbfba2f4aa51b6c8d06cd25a5734bd64c4eac4dd642bdf05e1c6a4faee1"
    sha256 cellar: :any,                 arm64_monterey: "d113ba1bce679f1b4b7167a04f678f40f97051cbb9732641757bdfa15daeb68d"
    sha256 cellar: :any,                 arm64_big_sur:  "8ea148a8b04c67f99de6e3195fdcc7b1d33ed484e091df7be1f065c1fab798a5"
    sha256 cellar: :any,                 ventura:        "11c314be0ee6875177503b0819e0f6cb8def0f4abbd37e9ff21605c089194fef"
    sha256 cellar: :any,                 monterey:       "20059832fbfeddd5609e82caf28f0db4d3f5bf3f467ab34b37f394db2d1c66e5"
    sha256 cellar: :any,                 big_sur:        "043501b77eaef66c715ab49ffce7964fc4a03eea2f9357bae637112660217e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249e0436a47bac3efb7d798d5c80252365f9ce09f0427b447bc00b31b96972ad"
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
