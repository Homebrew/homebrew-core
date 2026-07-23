class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://github.com/openturns/openturns/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "d623233aee0aa1f0fee204cfc9297f9c910e858af8df2560034c8ad2f2d31adb"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "02e1e0f9a46c9f068ceeacfa1492638c7db616da13b630ab139b04cfa0853b48"
    sha256 arm64_sequoia: "a50cfa4a30b6a30d04de93572803e24e04611319feec927963546c120d3d42f5"
    sha256 arm64_sonoma:  "6264b20c5bf6c1380c33843b6ff0191ed277d6102aae3684169b9193a389943a"
    sha256 sonoma:        "8e1e6ccf1116ca8f325b8cf2b1c3b23b2bd876aad569a6a87a52fd4bffe1de26"
    sha256 arm64_linux:   "1b195873529073b5ce650eb57602b6fe21e18459461297734c0adce475a90355"
    sha256 x86_64_linux:  "0281b679f6a396298d7bed41a94983afdcbc3960ee5d514e151058851cdab3eb"
  end

  depends_on "cmake" => :build
  depends_on "nanoflann" => :build
  depends_on "spectra" => :build

  depends_on "boost"
  depends_on "cminpack"
  depends_on "gmp"
  depends_on "hdf5"
  depends_on "highs"
  depends_on "ipopt"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "nlopt"
  depends_on "pagmo"
  depends_on "primesieve"
  depends_on "tbb"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %w[
      -DBUILD_PYTHON=OFF
      -DCMAKE_UNITY_BUILD=ON
      -DCMAKE_UNITY_BUILD_BATCH_SIZE=32
    ]

    args << "-DBLA_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <openturns/OT.hxx>
      #include <iostream>
      int main() {
        OT::Normal distribution(0.0, 1.0);
        std::cout << distribution.getMean()[0] << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lOT", "-o", "test"
    assert_equal "0", shell_output("./test").strip
  end
end
