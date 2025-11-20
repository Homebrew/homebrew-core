class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "cd0daddaca57e66b55524588d715dc62dcee06b5ab9ad186412dc23bc71ae342"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bbe500a50da0b931796c0bc0f20568c6ab7854a3848c8ec457bf55a0185b87a"
    sha256 cellar: :any,                 arm64_sequoia: "5660d2ecd3aaa09887bcc6dc7ac20f289006679c364c1edd56224fbf61d493df"
    sha256 cellar: :any,                 arm64_sonoma:  "2c586667407bb8298f20777dfc044098f0471d4b093455acf65b36f083321a58"
    sha256 cellar: :any,                 sonoma:        "be40fae84781ebf8108c4647b125f8e5d2a874a8b2cac776e02f1261e28e90b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "948550cc36b0b0e3799f20fe509bb9aa8fd3b65bc14861cbbc7d18e5ab29f450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28b51bf3b9155f286d5c6451f13f8b875f1a14d02b8e118b667efb16fa673a1"
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
