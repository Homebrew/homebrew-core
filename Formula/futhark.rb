require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.12.2.tar.gz"
  sha256 "d5dae8e03d86d01909edc258f51130bc18bbf79523571a17b87c3502512be495"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "168c980fc04ce1c8eb82c4f6c861d6a1a56d02da28ee5fe397634d0b9750ee65" => :mojave
    sha256 "f884dcbb328d0ca6805bce9179462ecf71b8f1cc70e7af6339ca4b52d2ff9ab5" => :high_sierra
    sha256 "0870f4b8af4ab70a18741865d56101493625d6b66b9fa37e198b80687e85bf65" => :sierra
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
