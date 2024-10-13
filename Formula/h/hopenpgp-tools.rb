class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.10/hopenpgp-tools-0.23.10.tar.gz"
  sha256 "5a89eab24143ed212b6d91e0df9cc00d9b0ebd3ccf7a0b65b4f29768c4044e29"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454c7f1db4aa75a3b8645cbfdcd55b0c3a1c48faefe3f4ea5b9d7fddd862544d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842b69bcbeacdb7a8debb729a1165d7ad16bc62e9938b20fbf98a136cf02a422"
    sha256 cellar: :any,                 arm64_ventura: "8d996b1a36cd2565b0cc00dfde4a820220d905acbba85d41d0620888a11da727"
    sha256 cellar: :any_skip_relocation, sonoma:        "824baa8add32bd98dda8c7a6358bbe789d1ee535c1ccc947eecc68e337544799"
    sha256 cellar: :any,                 ventura:       "36be45e7e532005ef1c836aee093666fdddc2cae27855146c13ac0dbc0b37ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522e51de7cf2aec5233d680e28502cc2f76deb153f5130a9a7ef89df87471f7e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "zlib"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
