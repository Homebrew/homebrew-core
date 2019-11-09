require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.12.3.tar.gz"
  sha256 "596ec75eeb0fdc21ab61c225e56ef5b25a5987420729528aea0aa644ccd2852a"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "937ffc26916fb5b76005b58a22b5fee73dfe36dc44dd8be41008172188fe3cb2" => :catalina
    sha256 "d4a37c48d9b266b6d1eb71d0222e305713468959f45ec53008d5a24af995ad9e" => :mojave
    sha256 "a1c878e19388ae359e9122bf14efcb51bcb715ee7001e15e717384c3c7c1e5ea" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"

      install_cabal_package :using => ["alex", "happy"]
    end

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
