class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/3.1.3.tar.gz"
  sha256 "9b512e4fe665ff73f9a0b3357420fc1f65af6205cbf74f2dfb55592e90e598d8"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f137068016782a1d1423bc6f14f1c70abcd6f30a40067b0a0d5d8928f072cc6"
    sha256 cellar: :any,                 arm64_ventura:  "0fd5f202207588dc87c12b6a04658a801b7ad8cef33701a332d4d5d7600f1776"
    sha256 cellar: :any,                 arm64_monterey: "b7f14ff0805657c3536c04d67a544579d0b057a0abd88b0106a3e82304a8998d"
    sha256 cellar: :any,                 sonoma:         "822ac8e1f9c21e04f85c4e1fd33ee586ec852816392bf8c281d33913df5ffc44"
    sha256 cellar: :any,                 ventura:        "0b722333335d58019e3c183d79c3152f392e8150a4ee38c1b1f3c30c83b78cb3"
    sha256 cellar: :any,                 monterey:       "4c4b11777cf9ea11d0ef9394f964896dab1d634e9f7547311ee1179f17f9cb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc43c051af40f07f6daeaa276a863013d11f7071eaf66b740d0898867a3114ad"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
