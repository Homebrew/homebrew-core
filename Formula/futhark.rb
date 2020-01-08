require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.13.2.tar.gz"
  sha256 "51b1c4bf3cac469dabbf66955049480273411cf5eb50da235f0a4c96cffe2b8e"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc6081107afb474297808dc8b632fa237a0e0a8580232077f04409a6561b0c9" => :catalina
    sha256 "ab8c1168033238ab7ca0ed6ae5855a18943472ac6d69a564ba335428628c9bb3" => :mojave
    sha256 "2644ffab0014bb6967fe0bc2d4f55bbcb1b7f4f888234420d68f6c9e83027d10" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "sphinx-doc" => :build

  def install
    # Futhark provides a cabal.project.freeze for pinning Cabal
    # dependencies, but this is only picked up by "v2" builds, and
    # as of this writing, Homebrew still does sandboxed "v1" builds.
    # Fortunately, the file formats seem to be compatible.
    mv "cabal.project.freeze", "cabal.config"

    system "hpack"

    install_cabal_package :using => ["alex", "happy"]

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
