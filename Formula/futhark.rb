class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.4.tar.gz"
  sha256 "ca16c30bcdd28ed6e1ac8fbffb4c77f3fe14c27fd987af3aa95562f93b1aa065"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4cc878945e9f25b8551a50c9ff8e7e25c8d55a995176c59e92adfee6f8654fa6"
    sha256 cellar: :any_skip_relocation, catalina: "c7b0a665ed49163d55644c625c92e6f1d25c7fcaa9183ae267f997c7a97a8740"
    sha256 cellar: :any_skip_relocation, mojave:   "95ee659c39fb84f3735c47499f122e29c31e4af2c530f13d611ab56bccd86159"
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
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
