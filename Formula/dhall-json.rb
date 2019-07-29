require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-json"
  url "https://hackage.haskell.org/package/dhall-json-1.4.0/dhall-json-1.4.0.tar.gz"
  sha256 "31832fd8bdcf27ebea805143f62eb570970bf42cdd93cec73fdeb81c6a38ab4f"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cee7a1435669e02ec2f8c1e0c0f52c343c8b099b1fe5182d1947e48e5a4c83d4" => :mojave
    sha256 "f01a9cf4deb2881366914d6f4827891c1b6b75b942554ed9edc95342f806cb24" => :high_sierra
    sha256 "78d2c752a076fcb058fc9a611eee333d484d097c46efe2ec7d29ca3d9a9857c6" => :sierra
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
