class Latexila < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.24/latexila-3.24.3.tar.xz"
  sha256 "a1df72539bbe3f84ba69463f7b6bceb9d964f08c4ef75909c1853c872d035870"

  bottle do
    sha256 "774ca73e811ecd4dd1bcd57f9a6a482be42939f4b0bb0431c4921414323ee196" => :sierra
    sha256 "55832e46ee032876b33c2db847b9d75b9089a5945d4b1f88d2bd4e3ea1674341" => :el_capitan
    sha256 "aa8f9c27221af8f7dede4a0af9f1c38dd5538f2bfa660fe3bdc89830fd7a14f2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtksourceview3"
  depends_on "gspell"
  depends_on "gtef"
  depends_on "libgee"
  depends_on "gobject-introspection"
  depends_on "gnome-icon-theme"
  depends_on "gnome-themes-standard" => :optional
  depends_on "libxml2"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
  end

  test do
    system "#{bin}/latexila", "--version"
  end
end
