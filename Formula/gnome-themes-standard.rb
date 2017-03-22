class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.3.tar.xz"
  sha256 "61dc87c52261cfd5b94d65e8ffd923ddeb5d3944562f84942eeeb197ab8ab56a"

  bottle do
    cellar :any
    sha256 "d6f59d31c2847ed0cb8538288bcb89f2c3740a9987e0d06707b309978b61c2c7" => :sierra
    sha256 "cde669051c2d96b22ee2857f44679e90743756ba5e8a433ceabde5123ebab8ce" => :el_capitan
    sha256 "211149e7a4fda4a9566fde9b3b8083022f8f3a5fc551b6e96765055ffafb9b5a" => :yosemite
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
