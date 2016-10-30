class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.10.tar.xz"
  sha256 "8038ef84dddbe7ad91c205bf91dddf684f072df8623f39b6555a6bb72837b85a"

  bottle do
    sha256 "87410e9f5a9aa1fb9b7d706d55762d540922f35fade1394ce8f65614e9d3a16a" => :sierra
    sha256 "a92492fb1109fd453415e73bcf2b7ac5e99aefa3ea85f863d94b741277394a6a" => :el_capitan
    sha256 "368db5c08311273ff6bd51c2f30afe9acfd06481c93191e76d73cce6050c128e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"

  def install
    ENV["ax_cv_check_cflags__Wl___no_as_needed"] = "no"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
