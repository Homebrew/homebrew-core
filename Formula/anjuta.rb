class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.28/anjuta-3.28.0.tar.xz"
  sha256 "b087b0a5857952d0edd24dae458616eb166a3257bc647d5279a9e71495544779"
  revision 4

  bottle do
    sha256 "3111ff1e5198e4505b17527924a1956f65162f673c88e02ee96e230530d1fc99" => :mojave
    sha256 "8713e98f2ceedb8d4070c7d4f10cd2fd6f68103fdf7299cffb5b6aca8cfbcf5d" => :high_sierra
    sha256 "899a5d1ef2499ed5ef9601d43f9bc4bcdf67ecee763473e00c849cd1d6a24c03" => :sierra
    sha256 "b6ff526b0b5adf18ac42b77d880286b4f3602d361dae8531c158e118943c0b67" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "autogen"
  depends_on "gdl"
  depends_on "gnome-themes-standard"
  depends_on "gnutls"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "libgda"
  depends_on "libxml2"
  depends_on "python"
  depends_on "shared-mime-info"
  depends_on "vala"
  depends_on "vte3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"

    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    system "make", "install"
  end

  def post_install
    hshare = HOMEBREW_PREFIX/"share"

    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", hshare/"glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", hshare/"icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{hshare}/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", hshare/"icons/HighContrast"
    end
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", hshare/"mime"
  end

  test do
    system "#{bin}/anjuta", "--version"
  end
end
