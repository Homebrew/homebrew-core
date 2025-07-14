class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2b44b074cf41439325ce4d0bbdac2d51379f56faf17ba15320a410d3c1f07275"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bc68b7f758c88dd3138326cbfb49ae166fbf321ce5ddaf7bbd69dc823ed8345"
    sha256 cellar: :any,                 arm64_sonoma:  "593e0fdaec4b5ff13d97e530a410787ed9d7995b13a284fda7f1bc3ee5a616f4"
    sha256 cellar: :any,                 arm64_ventura: "9129e1d9e165e903c1a0b7a591a16fedf7ec5980d1fbbce1541439362918c73c"
    sha256 cellar: :any,                 sonoma:        "a318a213d55bd42994189176bb363c38d3ff4ddb57ce5ed59401d1542d6c787e"
    sha256 cellar: :any,                 ventura:       "f03d69b1aba09520d6b6b51415c0ce35d47012fb5acf21552d468a61bd1578b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5170b7eee06a3ba3e6e55e97fc7ffdcf937422747c6231a1a21ad37f3b422f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a438aef2249268159f2a1c90b67b63fd203cd06713eb84ddaa31dfb2ee3166a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
