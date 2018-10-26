require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.7.3.tar.gz"
  sha256 "fda334f9d4b5500dac191240f59a45d3eeaf15a48c56ccac02c3bad8357f0aa1"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b90c515f3dd670fd470503cd13a3fb8c7c377944e4566940953aa02b48fccff" => :mojave
    sha256 "e61a1343393b3e9009b47f04f4e87b254a63a188f67ea8ab3cda5962003c656d" => :high_sierra
    sha256 "7119fca7c960a2ac254c36d534048c1a253a83910956f098a619b161e82f298f" => :sierra
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
