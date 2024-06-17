class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "65c6f9fc2365ced42ee8eb2d209a0d3a7942cd59ff4bd20464e195c433f3a885"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff6d469ad1efabbd7782fed6fcb5987a3e9b77ef3c2bc377732958c688fd34af"
    sha256 cellar: :any,                 arm64_ventura:  "1fd9037386d327810cb727cf0703c75ac62f91112cba1c6b8ded6320bbced663"
    sha256 cellar: :any,                 arm64_monterey: "70ffe3a9b042c169648de0a44b1d1104a2bf390c5ccb722d00c5255c1824d6a6"
    sha256 cellar: :any,                 sonoma:         "5492ff5446a83387bb18d86f270783d4b49bdde878b05a59a6cf3f9e25cc8f89"
    sha256 cellar: :any,                 ventura:        "acc045e45b71ab3aaa0563bdbe4fccadf3c4f6ed4a1b65363abf4a9c9cb8a8d4"
    sha256 cellar: :any,                 monterey:       "61232821b26abd38e293b4943602d662ec28b06705fa80ed226b3a19405e7807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07b10252ceee3309f28c1a93896026e779f88b2556b106b0f2f2c76cf495957"
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
