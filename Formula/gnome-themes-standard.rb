class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://git.gnome.org/browse/gnome-themes-standard/"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.3.tar.xz"
  sha256 "61dc87c52261cfd5b94d65e8ffd923ddeb5d3944562f84942eeeb197ab8ab56a"

  bottle do
    cellar :any
    sha256 "628cb3dafd7c2577efe0541a200c190d4a8b7653e5e806f38f6aa4d79f4d872b" => :sierra
    sha256 "92177002751416a5c288faa4a22343dd6b40d0bf056cce53108aa371d9dce0bb" => :el_capitan
    sha256 "13d5ff2e6d7497d5eb32d2dcf1794c4541d0d38a00e02f00a42ad83457b507a9" => :yosemite
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
