class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "9f05c94cc2b017ed13698834ac2a3567b6339a8bde27640df5a1581d49d05ce5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69c4b39ebd16770f33aaa3ce9023484e52c80d3c27d4f69e243e5be414c9237c"
    sha256 cellar: :any,                 arm64_big_sur:  "3537ce70aff1b7d9bb8b0dfac8da2b404ebb92f483c40e9dc56ac7d098459f5d"
    sha256 cellar: :any,                 monterey:       "60f36a99ebca794366457e80b6847d0cf1c17d7bfae13ce49efe502bd5af4514"
    sha256 cellar: :any,                 big_sur:        "98c9fa19f7c7a34603129ae7c92da4e127f52eab822dc74351ee8c30cb628489"
    sha256 cellar: :any,                 catalina:       "37f9631af5e05af08eb339d800eee4b940f86f01b49e92a4281d4a508fbb91b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8740d8eb3ccab83e3832e28659165d5e93a083206ce0370125bf4dc43dada0e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
