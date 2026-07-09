class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.4.0.tar.gz"
  sha256 "e72241ac9524bb653ae52ced768b508045d4438726a303f10181a38f764a453c"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a17f51ff9c2f22f412db35dacc63860a7e1c722f08fbf308f05f9f4db21db0d"
    sha256 cellar: :any,                 arm64_sequoia: "bf5268ae192ebd188db4892567d45eedfa42ed1d1d41665c8822e7934ccf9a9c"
    sha256 cellar: :any,                 arm64_sonoma:  "a5f109bb836022f065fe820e1b326b7f2bc92792604d362474e9bb40d1509d76"
    sha256 cellar: :any,                 sonoma:        "d953af12375d3afdfb19752f698acd9ed362245af9f1856503e676107b89495b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "385bd6949921be2da9d35a440220c7cf40a65d3a2def48f3890c9bcd7f6b0b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba94692faedb5e8fb7655dbf3175d3e224746c52444141c028edba76275c157"
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
