require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.2/dhall-json-1.0.2.tar.gz"
  sha256 "a16ebf9524884d0ecfa2963a6c4f15a380d0fa679b0bf0f342345535a18e22ea"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77ac80e1c7cd686d9756901a5d9cad6af03b52bbb062eaba2d4884e3639f6d96" => :sierra
    sha256 "88e13a41c5adf88b6a78539d563f4478ec7b7b6a9a1380ffa27811d44fc8cbb2" => :el_capitan
    sha256 "243428e30a1d0e2fc86608bde06209c3cbf8c575a5f3cfc4a052e804168b1977" => :yosemite
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
