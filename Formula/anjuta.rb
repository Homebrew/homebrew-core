class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.34/anjuta-3.34.0.tar.xz"
  sha256 "42a93130ed3ee02d064a7094e94e1ffae2032b3f35a87bf441e37fc3bb3a148f"

  bottle do
    sha256 "66bc5d99d0c5ab823e283c01cc0c7af5294bb095f20bdb99e9b775bc408968c7" => :mojave
    sha256 "939d047893f21a25ef7d79915dc18ff2ee62462fdf830a417bdf57a105826656" => :high_sierra
    sha256 "6ed200a7ee0a39f773117c5d69d60255a11004152f3f56d7f8ff8a819b15f156" => :sierra
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
