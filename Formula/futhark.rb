require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.16.2.tar.gz"
  sha256 "04382ba345b530960312977027e0acac36ec84bfb7fd67830ab372ff696b2218"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65b5559ff52b6ae536cf9627bfb9b72beb166a4c42983a8bde811c7f8632db70" => :catalina
    sha256 "52c171f6e026ac662e1e6c5b884c3373d0c81550f14a697e227bd593a8d480d6" => :mojave
    sha256 "f201df38b37dd934ad29721dff0736ae78d2c0f3685f87df007518c0a7a78bd2" => :high_sierra
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
