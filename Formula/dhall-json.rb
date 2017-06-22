require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.3/dhall-json-1.0.3.tar.gz"
  sha256 "bee92f6c0ae8eee3a8556d5f519aa57263bcc1350636d6d359e5dfb9d91e6be0"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cc38f3c5d3993958c8a31e421cd7eb12a7068d4d48d1a1f480f469599cf8213" => :sierra
    sha256 "4d25de13ed7e67c290861e6c52e68ca8efe4726bcebca9da91b2165fbef5bcb0" => :el_capitan
    sha256 "f84a989654d70f5bd451ac126b08910a58e4d29e13b90f4fdb6e17af02f031be" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
