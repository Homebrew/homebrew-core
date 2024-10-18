class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e184e63101cf19688a02102f58447acc7c021d77eef0d3475ceaceb61f035539"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c8a424ed44a9d27f7968c755d5b10bcf06492316bd19083b84bff767f7a9b87"
    sha256 cellar: :any,                 arm64_sonoma:  "f98dea74b12f883d74344e2591ccc1ab7fb9c4bfe869a163fc59551159cbf0bb"
    sha256 cellar: :any,                 arm64_ventura: "342d0e80f0e5f8c022de905ba7746b2bb840c7030c85191317764cb947b0294b"
    sha256 cellar: :any,                 sonoma:        "c94f89d61cf61d37344413cf38500343edece84909536d044b8301aaa0d3a04e"
    sha256 cellar: :any,                 ventura:       "b260ba8a39735e697187026649577d4deb07df483ca518e70041b882102aac11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "134ffbd41f2c522b24c93d866ca2fc89854bd647121fdbfca4d399e585f4ce19"
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
