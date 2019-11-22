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
    sha256 "33c6e90db9b773a185d8dd3a942513531c9eb713bb45f84270d6961b4bd6cb86" => :catalina
    sha256 "d8d3344b7f1ea69bb2dd8d93e846d3fce7119e971f201bf40a9947765e330873" => :mojave
    sha256 "7c77ffdfdfdeaa99530062ef74a01f1e4e5dd00b7e653b2690c79ca064f7406e" => :high_sierra
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
