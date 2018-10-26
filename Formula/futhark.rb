require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.7.3.tar.gz"
  sha256 "fda334f9d4b5500dac191240f59a45d3eeaf15a48c56ccac02c3bad8357f0aa1"
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
