require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.2.7/dhall-json-1.2.7.tar.gz"
  sha256 "11fca18fceacbff9f3b3ca86012f45b82fe9d52d2e689cfec434841a6e63e3f1"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f11856cac3d2516d0e7d53db129f1b4cd273ee9e073f145a4cb167ec3e167a1" => :mojave
    sha256 "ad0fa0e553afa962b8a006a0c1bd715e321e5797193589f63f2b1185e7759adb" => :high_sierra
    sha256 "fb36ce25ef819842687865bd82f857998ce9ea1d4b133566d78fcf75b8c536f0" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
