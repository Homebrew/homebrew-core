require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.15.3.tar.gz"
  sha256 "0f13890f9e2eb0b487be53a2c26c71d1bad19a9ba7a6fc5e72f3c03cfbe6c220"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2325ff3209309e850b3fd878dfc8b6d24348301cd740157c915ef8f05fd38211" => :catalina
    sha256 "3d6808c1a2801f7f03e657e240f08fc6b2a69761cf85df74a5a9204e4ed4bde9" => :mojave
    sha256 "f5318ecabb4c724c373529ae506b288542d9c7ae1beb99e0222acedc06bf6d17" => :high_sierra
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
