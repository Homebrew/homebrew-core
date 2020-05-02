require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.6.tar.gz"
  sha256 "fa332b217148ca5d8031265fdb427e04c11a847053200ad91dea1cefab4ba624"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9731d48f18595b47f09c54670864b9361d946ff276dafdcc85328b328002a4a3" => :catalina
    sha256 "17da914d41928e51b47a9bf926ed694f808300c4ca99019fef8e8581cd89b5b2" => :mojave
    sha256 "f0a8d69fc6b30a0f22fad3c1e63d9ddddf305edbea9dbc47090f013fb7d9c0c2" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # needed to fix a build error in v0.15.5
  # remove in v0.15.6+!
  patch do
    url "https://github.com/diku-dk/futhark/commit/b862de37f1e2cd7e7b561b723d01da9c8d248881.diff?full_index=1"
    sha256 "be6a39f0eb259b190e60f5c4d363e11008adf789261ca258a3fb6e1be75f3afd"
  end

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
