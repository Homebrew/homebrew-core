class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://gitlab.gnome.org/GNOME/gnome-themes-extra"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.3.tar.xz"
  sha256 "61dc87c52261cfd5b94d65e8ffd923ddeb5d3944562f84942eeeb197ab8ab56a"
  revision 1

  bottle do
    cellar :any
    sha256 "41e097a2fd0ab5fbf15f6f80c9c7b8760ab6b6ae44db89481a4815276b11c78a" => :mojave
    sha256 "89dfac449612ec50fb5f051b225ebc78cabf41b087547c2e5b1d944448d3fd78" => :high_sierra
    sha256 "4b2899ca297207b247e36b3e3c57b1cf005d4fd6b205f70453f71deb4486e42d" => :sierra
    sha256 "4732342c9072f0ab20bb83dcf358b44358a77176eb8275260669ba5badef0acf" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk3-engine"

    system "make", "install"
  end

  test do
    assert_predicate share/"icons/HighContrast/scalable/actions/document-open-recent.svg", :exist?
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libadwaita.so", :exist?
  end
end
