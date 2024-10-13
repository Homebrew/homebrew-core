class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5ff96c14ae19592d3568e9ae107624cbaf3409d328fb1a586359f0adf9b34bf7"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d0c9b3ec18e70565fd1173d938595705b7134ee59199d97a74b35b31364dd8b2"
    sha256 cellar: :any,                 arm64_sonoma:   "6e0a9593505baa0d95894861d7f201554d767ccac37cbf0692d7a3be055a5f3e"
    sha256 cellar: :any,                 arm64_ventura:  "094a768e4547999482bf4e10b5662e10cb0db453f57a4d749a81176a35d585a9"
    sha256 cellar: :any,                 arm64_monterey: "586be157934927ec7817305f333a1acd011c5d683dc458de08860f317fcc4d2c"
    sha256 cellar: :any,                 sonoma:         "cdda4454e4edc4f691ef4f92a2caceb99a9e7341a93c847b64df1c5b7f085638"
    sha256 cellar: :any,                 ventura:        "f93ba4fbe164ade8686b869d7d4a7ef4a9c5d9f7d96a2fa0776af74bcffdbf99"
    sha256 cellar: :any,                 monterey:       "87ce36dba1029c9cd64f670cae49c3a5052c370126856d2726f51fa04ebf9d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f79aac054788d29037129bd3f15732c39bcc16fd28167dc5fc092a107ae8db"
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
