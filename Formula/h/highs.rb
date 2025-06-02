class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "cf29873b894133bac111fc45bbf10989b6c5c041992fcd10e31222253e371a4c"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "119488a2ba901dadad44f18523a0f3d95c9b2ddf8ef4813d5e6dcf9ff6042e81"
    sha256 cellar: :any,                 arm64_sonoma:  "29deeb714569915e5102ff6fcc8fd31a88d2c1f658047fb056bded24328c78e2"
    sha256 cellar: :any,                 arm64_ventura: "8c8e22fc0e5d246880e232ca0360e1aafde2d3f6d53a893195fc8eeeb2a9b4b6"
    sha256 cellar: :any,                 sonoma:        "477a2610423ff1509ee37a45879861e7cd92d067a582b5e65f9216a29e0ea09b"
    sha256 cellar: :any,                 ventura:       "2d47d187c483c4e3c3a60f4fad733a55b7fe3b8b3e62aa2999144fd4d2808156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c60abb5e3d3a231de96c15abc55cf7f21d7cf22d17189ff03809ac2d5409908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7a0c25e31afe2edf9707ddec00c82b66389631377ed30baf43a11e475dcc67"
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
