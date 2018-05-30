require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.5.1.tar.gz"
  sha256 "095ea369d2c662e7dcabe64712865782454d6d9fbd60da0bdcd100064441ca43"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9665e9e97e6b78b4b873025eabaf80c1d3875fa72464cea7c3b650b7279ebf" => :high_sierra
    sha256 "53d7d06292d2d0e3ae71fcc898d75e7113a43cca87209e658c77f2ccd9b79be1" => :sierra
    sha256 "10711908562115e2a1e04dc60019940faaeeb93602242a8456a3f1c426301e85" => :el_capitan
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
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
