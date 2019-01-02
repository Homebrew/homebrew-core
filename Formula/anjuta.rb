class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.28/anjuta-3.28.0.tar.xz"
  sha256 "b087b0a5857952d0edd24dae458616eb166a3257bc647d5279a9e71495544779"
  revision 4

  bottle do
    sha256 "b161145bbb89ab51466f2a82f0e44d3b9050ac4bef2e72b1490bc5111bb329ae" => :mojave
    sha256 "847cab22d1e101f20e5dc1f02041a6ec9570a18258ebcffb4afc6c431310f028" => :high_sierra
    sha256 "1c49cb3084e1b742802fbbfde8b604b2477700cb220bd8d42cfb3b2e04f07a62" => :sierra
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
