require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.7.1.tar.gz"
  sha256 "6f36bc190c5ed65bb810169bea184ca727f4f633e0cbd3bccd1e17ac88d814ff"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b3298c1cf129f7e82b4fb0c985e9469856cd87451e52e7e016cf5899702c383" => :mojave
    sha256 "e1c56284f092e325019d8e507453d9f330fb270a49819b69761fc0190f5eddfb" => :high_sierra
    sha256 "483842159645e86c9707f256255f6d38bc941e7b44ed8ae0863eced8909fc177" => :sierra
    sha256 "0d0722942f875eff533d6a4668ebd6b0ba2ea439f6e12b86f632008c9d7ca040" => :el_capitan
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
