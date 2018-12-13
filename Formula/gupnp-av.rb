class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.11.tar.xz"
  sha256 "689dcf1492ab8991daea291365a32548a77d1a2294d85b33622b55cca9ce6fdc"

  bottle do
    sha256 "42b45028bd4f1fdc042c02f3c5087924f940a925dd62e6e397cbeb0331bd80ab" => :mojave
    sha256 "ac4c7a4be3cd9d0b59c9a601ab44e8b3246a659bb97a1813c46a9925b36ded66" => :high_sierra
    sha256 "05a98ecd787aa47ec3a4f8396890c8727dae8f404db2a928fbd7519973c849f9" => :sierra
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
