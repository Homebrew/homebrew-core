require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.7.tar.gz"
  sha256 "59fd3f151c75f081b0c28746e9152facf90b7edd9b404b9f596da505b70a94f5"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5018e39d14b26590ee7e1792f621ad1dd17fd74893800614353d2d5016b18d6" => :catalina
    sha256 "fd9fd8ad1ca7eba88d45a6b2f8bdb8b61a455b7e74582644a935cece2727aecd" => :mojave
    sha256 "daa76d9d953496b5b0858d36fbef57af9a996168fd50ad31fc5e4caa0af210c2" => :high_sierra
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
