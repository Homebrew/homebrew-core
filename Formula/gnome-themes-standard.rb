class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.20/gnome-themes-standard-3.20.2.tar.xz"
  sha256 "9d0d9c4b2c9f9008301c3c1878ebb95859a735b7fd4a6a518802b9637e4a7915"

  bottle do
    cellar :any
    sha256 "eaea0e40b04738d05114e7aa3584a3a2d385853947a0e11d688b2c42c77cf232" => :sierra
    sha256 "04e671e47ae0ac13b5ceb58f72bd8a7d79ce1af12f2e24e76c94095071cb5dcb" => :el_capitan
    sha256 "759bd07bb814badff507ed1c1194445c5ca584969e5bcadf1feb49fbbc60aeee" => :yosemite
    sha256 "eb1b0bfce8a25e427f9c95ada48d4cc45de13a844e0f7493f09872016a84e54c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk3-engine"

    system "make", "install"
  end

  test do
    assert (share/"icons/HighContrast/scalable/actions/document-open-recent.svg").exist?
    assert (lib/"gtk-2.0/2.10.0/engines/libadwaita.so").exist?
  end
end
