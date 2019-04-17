require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.10.2.tar.gz"
  sha256 "6a389196d843b583ab33bf1b844b6898868ddb536e99cfb1d03b80534c52b4eb"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c11527c221bcd225dc9d25a2a913e4a8e068c0e404c3b420de36ec4604d6aa2" => :mojave
    sha256 "a7c3d6f2f5a1aa82fe89c23841bafa7336f16274a5a83d1cdd38d56d89c4bb9d" => :high_sierra
    sha256 "0172254dfbb2894ecfb518145df4f8e74a6b01d595c4c5f28a021a80bbde4a85" => :sierra
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
