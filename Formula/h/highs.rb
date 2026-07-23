class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "a840d269dff2fafb371dd247df13ad5e026d7ce3b35ad3dc1eedd59bf0c2fb16"
  license "MIT"
  compatibility_version 4

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7065ab57341a0f87fc871af14ae92ac4c065fccf93062d1a74683de8d7ae78f"
    sha256 cellar: :any, arm64_sequoia: "270b098a9d4531bf7231c83229d2a6349b973af0fca85f43a2ad01a2bf3b5586"
    sha256 cellar: :any, arm64_sonoma:  "0a850956801830bada13e9ddaef57f9e8e83e07b35d426821b1e60e875bb243d"
    sha256 cellar: :any, sonoma:        "a862c48545dbe8806790523b519b7d4ec62bdd598974e0f0d3591f546856f1f5"
    sha256 cellar: :any, arm64_linux:   "ec6c40f034ea5c11f80e32ea0a80c7ed95f7ab786933155bb1a67e160fcdf358"
    sha256 cellar: :any, x86_64_linux:  "0fca654e3d99718bf0308bfe08f5845c9771865af9d0448bf8e730bcae0d2935"
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
