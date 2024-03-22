class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "d10175ad66e7f113ac5dc00c9d6650a620663a6884fbf2942d6eb7a3d854604f"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "43722c245ce256ca784ed3fd663b6c7399fba931e331426485ba23c2790029c5"
    sha256 cellar: :any,                 arm64_ventura:  "b90f19b9d3c88b56ce1a5d0ce092f1f3b542612b32e72617f72d571d92b69510"
    sha256 cellar: :any,                 arm64_monterey: "071e46829d7afa5b6eb0a7a5a482dbed5be9dddc5f2f2622de085d5776e7890b"
    sha256 cellar: :any,                 sonoma:         "b72c2c031d50dc89fa79d727c94232624322f8ac3cb43f175b1602bbd6344ba2"
    sha256 cellar: :any,                 ventura:        "93c417383e651e6a0649e66ef64ed087aee61226a89c38541f5d68e0ddb394d2"
    sha256 cellar: :any,                 monterey:       "b28e6609fdeb8c73f3a4bb7b485961d35934e942a0b3705c1b9afa76e10d919d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6558b7e71dff08d3cf2727231a819d7498bf1fe736d8bd014934b25e28f1a540"
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
