class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.1.tar.xz"
  sha256 "90f6f4e79eaa42e424fa35144cdbcb5db93db56e73200ac045742ba320febb54"

  bottle do
    cellar :any
    sha256 "77e463ccc14696060f780313933d6867b31141ea6312fd3883adc74dad04ad37" => :sierra
    sha256 "6db25a2227ca8793ce4cb4c64dd5853829b1c481cf64821ddabb7b63e436f51f" => :el_capitan
    sha256 "3265fe54f19e77693be6bfe669b054f6cc84e3bc15d10b8c80e51c93141c0d7e" => :yosemite
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
