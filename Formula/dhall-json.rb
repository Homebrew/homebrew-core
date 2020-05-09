require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.6.4/dhall-json-1.6.4.tar.gz"
  sha256 "3f0162949d53e10c23ee11ddfe92a808dc5b18c5a40289015c65baec0450266f"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8baba28ec96207d261ba4c9e3a35417d7aca9a06ffa5fb0548652210b409d279" => :catalina
    sha256 "bc4659ecb7eb1e05f997b6ace11e215d38482ea28f5a21f67b85ab1f466edf96" => :mojave
    sha256 "181c4e3f02021b7aa26390ad8991ea8ea92d203fd30d5b06552e64fda306196b" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
