class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools."
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.14.tar.xz"
  sha256 "682b952b3cf43818c7d27549c152ea52e43320500820ab3392cf5a29a95e7efa"

  bottle do
    sha256 "f94a0481678341db562af6a1977d69649b458eddb62971d17c92af750e010931" => :high_sierra
    sha256 "035592c93a08a17f3ead3010f656495b43ea17f4f2c535178e67070653d1daba" => :sierra
    sha256 "efa1f750e2768d384a60680e53ac08fd549dc13c36625d96fd61bae36db31c10" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "gtk+3"
  depends_on "gtksourceview3"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
