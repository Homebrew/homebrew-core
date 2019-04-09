class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.11.tar.xz"
  sha256 "689dcf1492ab8991daea291365a32548a77d1a2294d85b33622b55cca9ce6fdc"
  revision 1

  bottle do
    sha256 "2315f46287325242356665b8d8558640364a0029dd76027d946c16054fd6ccf4" => :mojave
    sha256 "84d2b14b760773f23f9c4029dfbc266f0094241fe0be984578bb0e7bcedc2e3a" => :high_sierra
    sha256 "8befa90132d2e237ff19284d6db59c3a8845fcfcbf2e33ca186cef4fb12ee84c" => :sierra
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
