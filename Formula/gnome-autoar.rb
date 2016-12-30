class GnomeAutoar < Formula
  desc "A convenient library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.1/gnome-autoar-0.1.1.tar.xz"
  sha256 "f65cb810b562dc038ced739fbf59739fd5df1a8e848636e21f363ded9f349ac9"

  depends_on "pkg-config"
  depends_on "libarchive"
  depends_on "glib"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
			  "--disable-glibtest",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "false"
  end
end
