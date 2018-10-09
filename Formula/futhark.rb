require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.7.2.tar.gz"
  sha256 "6e28034674a5c04766e467dadb59598b37f83c4b42d53e6e5b45f0756ada5aa7"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce1a04e0031937958626ce5837f354307b2fc41e5372bdc30fa08fd5d868381a" => :mojave
    sha256 "8a3d341f54cbe5c0ba0f75d5b56330f7fa9e5999ffcd3ec9225007fad57d5633" => :high_sierra
    sha256 "1b148097140f90349b99a2dc0abcec2a57a800e6a389e5a88d34cece9f77cef0" => :sierra
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
