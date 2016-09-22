class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools."
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.12.tar.xz"
  sha256 "658de96953608c4b1f47578ae563a7066d1f1983565daf22ad52b7b328ef97b1"

  bottle do
    sha256 "ddfff4bfbf6da35a8439146f578d34fb80cc3625086b14b89f24d8f4d58db926" => :el_capitan
    sha256 "a4bae3296dc5d8062f3826a4265e622330098ac1d1f3756ce8dc59404d1ac1d6" => :yosemite
    sha256 "aa42be7da9a3110a14546bf9a45f9fff2e484ed5b5a7c1360f4b02a94daa5f75" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "ossp-uuid"

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
