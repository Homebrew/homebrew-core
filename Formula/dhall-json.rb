require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.1/dhall-json-1.0.1.tar.gz"
  sha256 "ccf235f785207bedf29ea42d4ee26b44c2d2777fda8aa8d0306beaca43960726"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"

  bottle do
    cellar :any_skip_relocation
    sha256 "2efc13fffa393645a208a495713d66f797b2ff3095eb98d48b8a79413039fd9f" => :sierra
    sha256 "f38d9d7467133d090eb12db0282620ec571479148f3a95eee290efacfc6b7e72" => :el_capitan
    sha256 "5a4265e9917ecf5faf3f9fdeef5f24932f36bd008ef286f3f49bdb84785a05d5" => :yosemite
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
