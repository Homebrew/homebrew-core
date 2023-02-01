class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "29330e284491143cd53a547c23178221df46423679a98f6684251e65cc384d2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99d84f9503723aa94d494bfd5822fb47682c0d2a5f367ad6f62620eee2929696"
    sha256 cellar: :any,                 arm64_monterey: "4f40fcd5160c5eff1467f73c7472ef045973530e31a0adb3b486fb1cdfc8db9d"
    sha256 cellar: :any,                 arm64_big_sur:  "cdc09f5a1b582099b30d76980d0526579546ea8d626c264dee8dfc15049f1f2d"
    sha256 cellar: :any,                 ventura:        "93f06ef7febdb7d40eca38d4986c1820b7899e56ebb1825fca79f7540244ad30"
    sha256 cellar: :any,                 monterey:       "84cb0d8c138cecdf025bb6d6ed38322e9232dc3a1aefd26c9e967ce2b3208a9c"
    sha256 cellar: :any,                 big_sur:        "a50c1abc5c0b796bc28545a3781764a064c3ed79e1a8fcebda4443ec17b2c5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c6b47c9dd833f6adcb9e0db6a4b29b9a35cf42b177821f947ce1dd57ab8ac3e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/highs", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end
