class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.7/hopenpgp-tools-0.23.7.tar.gz"
  sha256 "b04137b315106f3f276509876acf396024fbb7152794e1e2a0ddd3afd740f857"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bba29c5fe72093581be4ee0cf64fe345b7f366b9784f4cf9071674c7c720bbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "723dcc2a9a37a9ad238c335c289b62474284ecffc30564e3a4b7281386476f72"
    sha256 cellar: :any_skip_relocation, ventura:        "106e20b9e9cedeeea379b9edce775842aabe5ed59efa0cd15843626f4f6d7b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "25218ccd4e41873383140eb223da71c0d018d08a62a213fbfe102e745c97b355"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a50ad11be71a77763353b97fcf5214c44b1fc495d616d189633e1749e649689"
    sha256 cellar: :any_skip_relocation, catalina:       "c82f967236223fcbb3245513aead6c3d34789031d3244440ec86c5aa4a95bd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2e44b2d4cf1ac3d71572ecaa5f4ba3d0ba882a1c9ed7813ca7d8edda546cc6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.10" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "zlib"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    # hOpenPGPTools's dependency hOpenPGP has conflict instance (Hashable Set) w/ hashable above 1.3.4.0
    # remove when hOpenPGP remove conflict instance or add upper bound of hashable
    # aeson has breaking change of 2.x.x.x
    # remove when hopenpgp-tools adopt aeson 2.x.x.x or add upper bound of aeson
    cabal_args = std_cabal_v2_args + ["--constraint=hashable<1.3.4.0", "--constraint=aeson<1.6"]
    system "cabal", "v2-update"
    system "cabal", "v2-install", *cabal_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
