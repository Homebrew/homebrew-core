class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.20/anjuta-3.20.0.tar.xz"
  sha256 "a676c587a28f784ec2096775460cd29fafc3f0216c53e0821641bcd9126b6935"

  bottle do
    sha256 "23a7b8a8cdf72eefaabd7702eb9dc249589852583716ff37afd38a2225942b79" => :sierra
    sha256 "45c434c27df740e3dd52a198a4f126c6dad780575d5fd12b8b58b25fc262fa88" => :el_capitan
    sha256 "bb3f2a1096b58a082d17b8e0d6e7ff502cc543d1d12e45017602050f5368fc16" => :yosemite
    sha256 "934b867228aad67b706d7ccb2a30d9c1c0035af99e65bf73f821e34c8e6bea55" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtksourceview3"
  depends_on "libxml2" => "with-python"
  depends_on "libgda"
  depends_on "gdl"
  depends_on "vte3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "gnutls"
  depends_on "shared-mime-info"
  depends_on "vala" => :recommended
  depends_on "autogen" => :recommended
  depends_on "gnome-themes-standard" => :optional
  depends_on "devhelp" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system "#{bin}/anjuta", "--version"
  end
end
