require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.0/dhall-json-1.0.0.tar.gz"
  sha256 "514e14a765b0fd360dad7aec62980ca02424d6670be9bf5b9a5a171835a7758d"
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
