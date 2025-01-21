class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "dff575df08d88583c109702c7c5c75ff6e51611e6eacca8b5b3fdfba8ecc2cb4"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c321f3658baa46d629748d62bac7c22d278c7d582ea79a0f1f3e3403894863a"
    sha256 cellar: :any,                 arm64_sonoma:  "dc96ee1daca80330321339a3d03e5ef7105c6c1357f8c045a37417df595241f1"
    sha256 cellar: :any,                 arm64_ventura: "1cb8bb55922993dcc9c157d5377aa632f8aed42417ff771801a8b499b32b5b43"
    sha256 cellar: :any,                 sonoma:        "e2e05016dcf50ba1bc9d8323cf1ad9493da0f0cfb3a365eb04b40f7c4314c708"
    sha256 cellar: :any,                 ventura:       "8c6b108a3ee9d87fe43d383c1118f7db9ccd9271fbdd3f21f27a78a46c5be55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143c28a7fce282c8bba26b7e3c238cb8323aa27f6581c017100ba3fe7f7959ed"
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
