class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.11.tar.xz"
  sha256 "689dcf1492ab8991daea291365a32548a77d1a2294d85b33622b55cca9ce6fdc"
  revision 2

  bottle do
    sha256 "6e0cf541932104a1259005b3d125d96c72c80e2dffc7d8d4b5ddb199c7bdd237" => :catalina
    sha256 "15f5c2ec832094d098ebbc52c1a327ce7e6125293180e7acc377bc7dcc3d5210" => :mojave
    sha256 "7149d11d69541003e8fc3b1d0da0b125b6dac5329db3017a735858363f31e78c" => :high_sierra
    sha256 "dc21d3e8e793fffde5b7b734be587f3a736f94f03f8bfa42ca5ae395be6081a3" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV["ax_cv_check_cflags__Wl___no_as_needed"] = "no"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
