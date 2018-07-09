require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.5.2.tar.gz"
  sha256 "c77dd18b910b1d7c934d2941db6b22591c53a2bc0c90addfa6f14df6747e080e"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dd79f3671f6c20261039e7d9fc4c95ca6423a757a8daecbdb9f3bd30b410899" => :high_sierra
    sha256 "0541632a0e97621223f81024f551844c5c57e1ee531ce2e1c05065229debbed6" => :sierra
    sha256 "c0c8ba6f62a4248c7bdf2e54a0830a45408b01f1ce1be1d312c6d177fc0d2e56" => :el_capitan
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
