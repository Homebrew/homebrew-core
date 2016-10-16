class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.12/gupnp-av-0.12.10.tar.xz"
  sha256 "8038ef84dddbe7ad91c205bf91dddf684f072df8623f39b6555a6bb72837b85a"

  bottle do
    sha256 "c450fea99ba2f8bca3dda25c50741a3cd6dc91b5ac888279ac2705c5b12a85a9" => :sierra
    sha256 "844eeb00212c5928c0886f7e777a24ae306f03ef1f8cda940fb425c39821dfe3" => :el_capitan
    sha256 "dc8416a36b758db5d6d5334edf19b446d99ca057d7c3f9be02dae5b9dca51058" => :yosemite
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
