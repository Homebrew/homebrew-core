class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "05931e8dd8c8cac514da8297003c31a206a0004d542b7da500810b85c87c20b9"
  license "MIT"
  compatibility_version 3

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cef4f4d3548edb590d6bc8fdb2137131cc420c5def0b6a7a0569b951f399eb8"
    sha256 cellar: :any,                 arm64_sequoia: "d26d1f6efe554d8fcefe6f88dbdb2e976dc9bf3e5f6fd3886ec9bc925a5cacbb"
    sha256 cellar: :any,                 arm64_sonoma:  "4c6b8d197d4b6e20669a09bf7d7fdb0aa3c4ab288147b006a0f9840addf7b5fb"
    sha256 cellar: :any,                 sonoma:        "98a9ace95fb8bef7337173bab209953c013b1a79dc8ef28e9b3cc156fb067e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83217af7a3f47e9bfbb82a36fe7c87abad407c2b5a991d2945be13c93035baa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "018bd3b27f5d43f0c80bc37bd9a0363d3a6e066970071bb7150ad519e3687b88"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
