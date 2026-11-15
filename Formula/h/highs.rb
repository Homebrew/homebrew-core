class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/releases/download/v1.16.0/source-archive.tar.gz"
  sha256 "05ba0a408e31fe933e4ee4ec9d0e244a0e3c5bd2613e7b138701f62708eceed9"
  license "MIT"
  compatibility_version 5

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f49333672b6b7fa8d9bdf3acb4fbe33ff76eebe56aac3e70d3ab5ec1e9a9f6a"
    sha256 cellar: :any, arm64_tahoe:       "2d235f7925d73c12d7bb461c8e98a1fd11949aaa1b255bcbc8a33b212782d957"
    sha256 cellar: :any, arm64_sequoia:     "c758868c9632031d093d776611d21f22c455ea0b7619b3a27702e16134d6fcd8"
    sha256 cellar: :any, arm64_linux:       "0a558678b6b75a4ac90dce3232009186ce62f8644d5cde0e021a755dc8c83bc3"
    sha256 cellar: :any, x86_64_linux:      "0d871d4f78a7cf450d092bc74ad4339ef60093e3e0efee8c519dd67a9c2f8e83"
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
