class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ed1819e6a36ae9c9c4c17959fef0cea54decca25985ff5c268dd4dd4f6dc3494"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17d4ebca894ef66c9d852b37ebdd2a40024de359e868f73ce94385213592be54"
    sha256 cellar: :any,                 arm64_monterey: "aeea358ffbf6f0b14086d94fe407278a644f2b36670b6bd41a45cad0e2f31eea"
    sha256 cellar: :any,                 arm64_big_sur:  "b819b631b68f0a18d5b571e8101562770a2f166232aba2b1b3a5b496956ac8f8"
    sha256 cellar: :any,                 monterey:       "003a12c68afa672ff0669821857d775462f2924deb25eaf55da4fd318687bd69"
    sha256 cellar: :any,                 big_sur:        "49010949aead7a16fa03582b527640d3bb8deb8d0cc9261e1ed7451964d8575e"
    sha256 cellar: :any,                 catalina:       "7cdce07d7dbfae57981169f199541b53fd98000dcb60d8fc199de30710d0b765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8603dece4fa47d35a439a70d66945936dc46751ce1705a16cc9c413bc9e69454"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "osi"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
