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
    sha256 "fd991de532d502cb54ea2cdd7705df1a31893309a9ef9286b4fe997ca6081033" => :high_sierra
    sha256 "41e3d8b3f5589ac6f6fbf3d7af782b309d3d43533fd7eddc10a4db6305fa8fa8" => :sierra
    sha256 "80521a7070e8ccea084083036c2d14d6d7a2e272457eb7d8f037650649004648" => :el_capitan
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
