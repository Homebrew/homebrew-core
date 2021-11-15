class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dmg2img[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fdcd63fd0d82e4a0d93e65cb6b31ade055f35eced526418c8f5bec74d9b66b74"
    sha256 cellar: :any,                 arm64_big_sur:  "11f7f409cae53668c66f6416581d9e33bd333aa544cdb53ca90e92684e5c7968"
    sha256 cellar: :any,                 monterey:       "b367b71768aff5e3299911d68d69cd63aa76179caaf631afad1a72f871ed4682"
    sha256 cellar: :any,                 big_sur:        "e1df6e7db928dd7e5d865968a527e310a7d1cad6f68c5a72c3bd717b75cef325"
    sha256 cellar: :any,                 catalina:       "e16b42ead321d5e0c85a98592154ef13a2206355a13cfe021735653a1dd995be"
    sha256 cellar: :any,                 mojave:         "fb90741dc01f5c7b115c9d5bf142e36a90d7cf0995ecb4a5183150ec6d6161ac"
    sha256 cellar: :any,                 high_sierra:    "367ab961e50114debc983e5665443ee8fa5a85a2b4fab024753f38df48fb26f1"
    sha256 cellar: :any,                 sierra:         "8616423fd5b0109c66a000932b2aa5bf4f3979c5a065617e8ef7dd4ae0ee820b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352d7b94084707e2138aa53245f2e3325c36c2faf21c7361fc81b0dbb9d8cabf"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Patch for OpenSSL 1.1 compatibility
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/dmg2img/openssl-1.1.diff"
    sha256 "bd57e74ecb562197abfeca8f17d0622125a911dd4580472ff53e0f0793f9da1c"
  end

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
