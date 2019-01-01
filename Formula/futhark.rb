require "language/haskell"

class Futhark < Formula
  include Language::Haskell::Cabal

  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.8.1.tar.gz"
  sha256 "0eec5d580b1d933e77266f52705d229b1fecf9ac2ee9cd8d72048a4531a3202e"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0ef8cbec3a613cf03b031af417044d2b2f8d27c55c765b7173cbdc4bb1516a8" => :mojave
    sha256 "9a442ac8df20baf422b3e89c61c7a6092eebd98ffb71a3f8ec3b318f2a1c87e7" => :high_sierra
    sha256 "77bf72590d9cab49ef92e84ee468cf1df59d83d1e780a9601f4f3cefd89adb75" => :sierra
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
