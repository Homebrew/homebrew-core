class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.7.tar.gz"
  sha256 "5434488108186c170a5e2fca5e3c9b6ef59a1caa4d520b008a9b8be6b8abe6c5"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fdd6b2ac3d54fc746adaa78d363d082561ac01b80fdf4283ee0cf7a750b1bf70"
    sha256 cellar: :any,                 arm64_ventura:  "11f8cb26c616f19979c723f39d2713248854244e2ee99e7904c6843f3456e11c"
    sha256 cellar: :any,                 arm64_monterey: "616f70b0b5f58ef58e97919dd4c5330317283f6f6f395527db0bdc5a91600a1a"
    sha256 cellar: :any,                 arm64_big_sur:  "6c0cf365c40393699ff80bfad9584c63c0bcf1637c653119a52ab9dcb6620a31"
    sha256 cellar: :any,                 sonoma:         "27680ef270fe253c96fb3248778bfd2b4747b666694d13d36eacba336e4ccbe3"
    sha256 cellar: :any,                 ventura:        "b052628c3dfc091104ad87770cd5a9a560b31587710b50ae84dddcef325a78a2"
    sha256 cellar: :any,                 monterey:       "c6aa22f976964559b6d61da87267a20da7070b82bdfccf82e7100d2c77688dd5"
    sha256 cellar: :any,                 big_sur:        "3ef04e6c59188ec81ce6f4148a25502bc5f3ef50364d315e84f9d8234808a847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b802284bac7d6a9ab1a17f986e8c00fa88eb63cfec911a191e81792940d9faff"
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
