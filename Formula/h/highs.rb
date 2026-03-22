class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "d491448e585dbf08cd8945ca5dcbbe3b784d73b9c68eea4e7456274619d56164"
  license "MIT"
  compatibility_version 2

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e187edab234d097ee02fe5dd18579d608b0520d24c8c506f186dfb00c865e38"
    sha256 cellar: :any,                 arm64_sequoia: "da1d2d4dcd9ad736ada97d45226e9f748aa981cc619e44a9eb45cdc9f8106a82"
    sha256 cellar: :any,                 arm64_sonoma:  "26d5df3940835c9b567b780c4ae218a83c18cca80e4b16371d301baf388df0e2"
    sha256 cellar: :any,                 sonoma:        "8fa13faae9b713dcf9e912062ea1a0f965d59e2466407a8257aad713d71991d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac654fbb042781c8f9f1d85dafd127560b0730714396f6e83beb41803b2df28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4771ad085218d7878dc5c6658195bf733b32a293d48a444d9c738faa0de61657"
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
