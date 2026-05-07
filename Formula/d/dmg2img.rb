class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dmg2img-1.6.7.tar.gz"
  mirror "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  # OpenSSL is only used in vfdecrypt so avoids incompatibility with GPL-2.0-only
  license all_of: [
    "GPL-2.0-only",
    "MIT", # vfdecrypt
  ]
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?dmg2img[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97e3ed053a2252ee6050c04f82331806b860b598b78da1d16df9230ab3c6d072"
    sha256 cellar: :any,                 arm64_sequoia: "84d01aa11f77179290362b3a5a2125982e0f1361cf3b6c3b978d2e759072bdaf"
    sha256 cellar: :any,                 arm64_sonoma:  "d11c36cba3bd4f9148c08bb5e091f9c2ab021a45c89f022b0b758579997ea465"
    sha256 cellar: :any,                 sonoma:        "15dbf70092404f86b2a856fba1a6843fa85654ccb61f4076155229f99193c9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69544e104e4f38a76e4e51a2ed351dc181524ec9db35b33b4346d49fcc532d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfb7f53e802e62022eef747edca601c5c05af8f3e926bca3af659c6e78842fb"
  end

  depends_on "openssl@4"

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
