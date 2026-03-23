class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dmg2img-1.6.7.tar.gz"
  mirror "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dmg2img[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "606ad411e551ca06e51b65e8e86db388a2f8d49a684fac4b803fc06adee95f1d"
    sha256 cellar: :any,                 arm64_sequoia: "e53bab095d09aa8d3d81a821708ac729baef3b6a9daac210b435597fff8126e3"
    sha256 cellar: :any,                 arm64_sonoma:  "fdd994d5c6ce537fbac1a97af5ef621cd3e2049588e4f586fd2c460b210b4069"
    sha256 cellar: :any,                 sonoma:        "4365149beabaf567f6b2ed11c2ad6e09989911c30be42a841e9b53f265bbe7a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58b6e5656e913aa9001e9b4a11ff670711e97bb96e129ab04a08ec64bf60924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef48b1f21bb0dd210883e31452368224a72fc775db03a15b95c29f61c1e41c82"
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Patch for OpenSSL 3 compatibility
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dmg2img/openssl-3.diff"
    sha256 "bd57e74ecb562197abfeca8f17d0622125a911dd4580472ff53e0f0793f9da1c"
  end

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output(bin/"dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
