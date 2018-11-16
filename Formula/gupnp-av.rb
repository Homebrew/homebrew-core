class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.11.tar.xz"
  sha256 "689dcf1492ab8991daea291365a32548a77d1a2294d85b33622b55cca9ce6fdc"

  bottle do
    sha256 "ed327db58bf2e4ab852c749b2de61ed441f1c20bc80c0656f9ee9304850a4d6e" => :mojave
    sha256 "022dbc5e4b3f60c9e32d55315ae2191a49f574172f550b74ad18625ebf326467" => :high_sierra
    sha256 "f65e6ee6a9d7e68bd261ccc56501db503088e3e63c9b42277bb07e30ab8cda1f" => :sierra
    sha256 "d5adf2d8f3eeb96a9910b2c41e0cc732226d5beeb4ad8a3edf091036feb3399d" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gupnp"

  def install
    ENV["ax_cv_check_cflags__Wl___no_as_needed"] = "no"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
