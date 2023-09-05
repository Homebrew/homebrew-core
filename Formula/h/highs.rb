class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ce1a7d2f008e60cc69ab06f8b16831bd0fcd5f6002d3bbebae9d7a3513a1d01d"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ddc85476f23ff1dcc4b808c831288f0c0be4871879ccfb34fac4cffdf4042cf"
    sha256 cellar: :any,                 arm64_monterey: "a746386ebaa3dcfc9f56883fbf3c2e846a2497d1fc938cec8f337a4636a8a63e"
    sha256 cellar: :any,                 arm64_big_sur:  "ca083f7a81d5193360f2dd9ede6ccdcf7e7b33352c11086158a8cfebd640b500"
    sha256 cellar: :any,                 ventura:        "74af44eee60e74784ade009cb5c28f457aa55642ab8a5d07a182c3fb69bfe518"
    sha256 cellar: :any,                 monterey:       "ee5676a86c071444b513fbc2992923d24cb210814fe8115e6af57b00dced1a1f"
    sha256 cellar: :any,                 big_sur:        "caa0400247e180d309b03841f8d8f3783a74d19b66a79271a8e2fbd7988c264a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcdcdfc7b341b01fb48cde55f2a4159609375d9a0b45c33cd4a6159c195e687"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
