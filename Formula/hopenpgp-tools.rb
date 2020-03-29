require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.1/hopenpgp-tools-0.23.1.tar.gz"
  sha256 "b28ac66343a0bf78b3bfb22cc87f85355909fcd49d9ba5ad43e5a0c38e8b014b"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88cc07df1b31c65ada4dd47dc78a3bcdd1017baa777ebb82c3d444c9a4a44e17" => :catalina
    sha256 "7d841a2f18aee831c985b9c11b2d8204dd83983483f8d8fa813be893452456ed" => :mojave
    sha256 "ce17132f983463ba3465a05a9c203026e5ea07326da34cb68224f035656ddc9b" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    install_cabal_package :using => ["alex", "happy", "c2hs"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
