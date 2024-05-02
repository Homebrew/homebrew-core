class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/3.1.3.tar.gz"
  sha256 "9b512e4fe665ff73f9a0b3357420fc1f65af6205cbf74f2dfb55592e90e598d8"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0ebdabeb908f95acba215c13d91353445e2500489b0ecb3cea6568bac21080a"
    sha256 cellar: :any,                 arm64_ventura:  "a06f085e1531dcc147da2a5a1c01fcfd99251d71fb8a223a143cbe4051dbe39b"
    sha256 cellar: :any,                 arm64_monterey: "5a68da1f7b95403f7b53054f341d6d78f883a6b1e0b79077618aab2e82780ec0"
    sha256 cellar: :any,                 sonoma:         "2ede863045d1646b9efea7ae595f37cadbaffccb8b8451bfdcdf06befd1b63ec"
    sha256 cellar: :any,                 ventura:        "d2b322ce31db8bd6971bc109d0e9d4cedf0f1952febc745b294d2a88d6eeb97b"
    sha256 cellar: :any,                 monterey:       "bf1e98c5eaf748babcf62bd47625e76d8ab066e140aed5fb363d36e3d2b052ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e893a9964a0bcf6948c676a5a776344f5ebc689af334cedb04ea8d03af52cc83"
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
