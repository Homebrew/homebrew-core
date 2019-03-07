require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.9.1.tar.gz"
  sha256 "9d77e04776004eff153585b27280192097f1ae54a62ca173a988c4414e88dbf1"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfe6048a06f884ad4e802a853e9b9719ba602361dc19109ca14d6b449b82d587" => :mojave
    sha256 "c9e557e01d02b09c5b61948d949e9452f7c8d7e3a7aa022ca5d4fe501b8188b4" => :high_sierra
    sha256 "200bc8494a95d5edc0653b89386e81404a1a4c6550dbb04de5e8d6e8028ea842" => :sierra
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
