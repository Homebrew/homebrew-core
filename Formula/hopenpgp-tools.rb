class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.6/hopenpgp-tools-0.23.6.tar.gz"
  sha256 "3df2f26a8e1c2be92c54b1b347474464a23d213a7982dd4afb8c88c6b6325042"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fc50e0b7b9c1d941d0b36dae6b6bb975d1635f801cdaa703c1ad8a70108c46a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28a2c5d4842abe810b28d5e6f4433e8b23308b68ca6c19c8b097fb27c58b5f88"
    sha256 cellar: :any_skip_relocation, monterey:       "3dda67da3f76b1739fee9f78a1d74702cb693482a4637f53efbbcf277c635351"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8ca61264f0399f95be40c4583b36604b4c64c9cf6ba761d209e4e722d4178e1"
    sha256 cellar: :any_skip_relocation, catalina:       "6b44cea08ca2095f1dd4a997ff852f862a58c0a18f56e74509061cb173405e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fac0a93a10aa5a26607c224db66c19ab6809776791200d14fb254991af88864"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
