require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.11.2.tar.gz"
  sha256 "a79d39fc0cb4251fadecd8077df4243a03c4c7797304783567137aec21eaec8f"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3282ade380310b4a74d52aad648b9c46a00d2641c00d46aed164b4e2bedf2ad1" => :mojave
    sha256 "1f3a5cfbcfd3c12f655beb97eb9f377d91315855dace21acbd3b3aa2339650bc" => :high_sierra
    sha256 "29e272a54eb9a17c451f6f8502f847a230857caf0a724e08fa8aec077f937eca" => :sierra
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
