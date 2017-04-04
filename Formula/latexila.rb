class Latexila < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.24/latexila-3.24.0.tar.xz"
  sha256 "2c47d6bf0a647715a3029af2b38099e9dac0c4a0a60c122917b36afd3f6ce31f"

  bottle do
    sha256 "ed89fce16151b4f639aace9da401b28d9a97b6e7d431d0db0501d463f91b1282" => :sierra
    sha256 "d72177928abac4aea9e52704c5d8b6b8c8b86a6683f05968c3010a6fcda048a1" => :el_capitan
    sha256 "1f9b9bac1620676ded276ba07255fb6bf33bb9ac88018453f4d9dde8b0a970e6" => :yosemite
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
  depends_on "libxml2" => "with-python"
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
