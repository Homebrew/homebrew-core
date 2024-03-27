class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.15.tar.gz"
  sha256 "5820a034e54fc4f511c15c5b16a5fa70bba739a10243a4f75f3cdd195c0e775c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "948e53845d394443c86108a9fea841d7d30fe17ab53f878899300b26c12c9676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862d3a6ed144f3505a69003ee30758a744314221f188e402f2a8385809086d34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2313a13e1452ff9c44f53263a024045dbef5cc2969221b426908a278fe2554"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ce0e3cb509a3581f4f4e7653da01861f7b19460753767ada6fe684a3945e3ca"
    sha256 cellar: :any_skip_relocation, ventura:        "8a0763d4ef4e33ff53eb9cc9c789cab7511ffeadb4f6990f5bb4278258e89584"
    sha256 cellar: :any_skip_relocation, monterey:       "3334a8eefcb6994bb1e747462134360506b3fb197d406696736e324196966180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0288312453bb6984e48b50aed250ee753ab5a9ffea70b263ecfb2f62f1f2aa8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
