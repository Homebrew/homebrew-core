require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.10.1.tar.gz"
  sha256 "e0d47bf9423cbea313323ccab17d21d07c487dec78bbe38d134abe5490b6faff"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1c23d305e2fef2f4324e632e5b5db23fbb8c1d5a7a82de37bf78614b889f6d2" => :mojave
    sha256 "1d35e096c31cc556a4c49568a1aacf1ec2a9a165d1a3622d8f3eaa2ebd22b31c" => :high_sierra
    sha256 "4668d39d9fff40a7df65e62ce59b1c19caf10bef83f97223e28ed24b469e1a38" => :sierra
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
