class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "4b9441cb991e372b2d4fa4a85e89db199befa1b0017a3275b45ad5ef734efaca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4a684b011f96af569fb32340d18a58b3359b61f89f1910fdeda21efe299b147"
    sha256 cellar: :any,                 arm64_monterey: "c9dd1425677efb108ded014763fac5d40d54bd2e33c0bbd33887f90acf08769d"
    sha256 cellar: :any,                 arm64_big_sur:  "e3df26ac9753742df94b0952646b059d46f5092c8a226544cc2cf0308abf71cf"
    sha256 cellar: :any,                 ventura:        "34e452ace5161f50329756ee7d397c7910dfdcc6cdadc8b34d4c994a39d0953c"
    sha256 cellar: :any,                 monterey:       "de80d9d305f440d3152f58662776eee4acbb7171b6f4f97bb38c48aa8210437d"
    sha256 cellar: :any,                 big_sur:        "ba6b57734736f84d0d6eb8656e50fcd4d419493e323239fbb6e9f27e194f065a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a59b79dc5843a6acf27c25d0a935cfa0ffb2b7e3840d7bf5ea0c6cb642420f4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
