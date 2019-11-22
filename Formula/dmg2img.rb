class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  revision 1

  bottle do
    cellar :any
    sha256 "e16b42ead321d5e0c85a98592154ef13a2206355a13cfe021735653a1dd995be" => :catalina
    sha256 "fb90741dc01f5c7b115c9d5bf142e36a90d7cf0995ecb4a5183150ec6d6161ac" => :mojave
    sha256 "367ab961e50114debc983e5665443ee8fa5a85a2b4fab024753f38df48fb26f1" => :high_sierra
    sha256 "8616423fd5b0109c66a000932b2aa5bf4f3979c5a065617e8ef7dd4ae0ee820b" => :sierra
  end

  depends_on "openssl@1.1"

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
