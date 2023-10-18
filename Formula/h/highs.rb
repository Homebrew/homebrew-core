class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "71962981566477c72c51b8b722c5df053d857b05b4f0e6869f455f657b3aa193"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75e89aa762d58dd8f25145f52cf88307965d276bd4420e55ed59a0edb21ad7dc"
    sha256 cellar: :any,                 arm64_ventura:  "042035464a1173577e6608b42f3276ec6a551b66ec5c1bc24145b6e38b3eaab3"
    sha256 cellar: :any,                 arm64_monterey: "cf16dc1e0d20ac82ca7ca4c9973c2dd2a73e6fa6b8987e1f09557f50ca15ce2b"
    sha256 cellar: :any,                 sonoma:         "87e8851e84113e4a324383d1faeb1ecd744d9fe7886d7b7217ffd63c1ff35fd4"
    sha256 cellar: :any,                 ventura:        "8c66deb23202a94ae4c0f358ce3e208d0a02be7c491e1741c73da7a6d0506203"
    sha256 cellar: :any,                 monterey:       "28d5a5cae5a0b502896997abde8d53db6c9d2881bc82139815c1c544418fbfc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be244b083f3ae08e4a79f4c71d103e5f9af7e7c45e5f25f9c1dc486c7cbfdb8"
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
