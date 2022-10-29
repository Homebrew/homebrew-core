class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.3.tar.gz"
  sha256 "95fe8c9d9923f9887457c83e4ccf9bf9f37f86b23124894afc7691939ce94d76"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b98a3353bb52543b042b2e914c82c3aabddbef5287da1b61228dfcf96dc81e13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64e82b742af11c7b42fdb4deef452b2a3900cb6597e74aa69762500d10a3213c"
    sha256 cellar: :any_skip_relocation, monterey:       "86d8918519b9f7f535cd7a91da71a0ec720921e7e78c9f31df82e4e22f21dc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "938889503d3ba3cec2eb0c49aa870b7d07a8e4edc7b4a8c169294f66780a1434"
    sha256 cellar: :any_skip_relocation, catalina:       "7a197d775dfc5f62c337737e0613e5d40082695063ddcbcd9533505d4903ec67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb319239f3e82cc4aa10d9884e6430c216a4d9794341fba5e2c5daef38cd8c0"
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
