require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.6.3.tar.gz"
  sha256 "9534d293e4d54234ed6a43bf99626ea1ceeaf769b6cdbb73599bdc17fa26f893"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49441eb8baa1a7ed4501cbcdd93e1fdd0c1c549b5e82b8b6e765f48f71af2ed2" => :mojave
    sha256 "10fea6ba4847bfca7c9ee78c4791884bfc24643ae6ae39091cddd9d7ccbaf1f9" => :high_sierra
    sha256 "fc6a3a50a77c96d1b119847f3fda9335c5d5002d6d3200663b9644aab4b9745d" => :sierra
    sha256 "119b615bc635798260530da1670abce212799b48f849cfba9869e0df85bebec0" => :el_capitan
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
