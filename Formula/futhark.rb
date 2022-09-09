class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.1.tar.gz"
  sha256 "f28b50a7bdc4d8b5b42e0e1bfe3211f8c1b51cd8ced204977c415f60e01f916c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14abb3ff8aa6023dd6d78b895b025e94821e829ea07188d1cef5f5722e4f5d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41b3b4739ea0369e9609bb16ecc472efca87ef806da82d3f3a8c348050e5f58a"
    sha256 cellar: :any_skip_relocation, monterey:       "02640b41689c8ebbd82ff7dc960b7c82a6ee32c87b510e26eba14cb6463e1b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7151bda663eb081167abbe0768c3cbf039dce1a7fefc05ec2a2d85723a6810df"
    sha256 cellar: :any_skip_relocation, catalina:       "1d085b13cc2d222a2d1a8fb070b0a9ba136e0e940e9fb3114d61afe20e0441bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c48d4c56104bb55486251a9e554be94cd393ef1cc2e2fa20850d4fb5bead4e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
