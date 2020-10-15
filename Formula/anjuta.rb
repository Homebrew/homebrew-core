class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.34/anjuta-3.34.0.tar.xz"
  sha256 "42a93130ed3ee02d064a7094e94e1ffae2032b3f35a87bf441e37fc3bb3a148f"
  revision 3

  livecheck do
    url :stable
  end

  bottle do
    sha256 "05830ff66d220192bfbe20dab94d811c3214ff10bd558188c366cbc217f14925" => :catalina
    sha256 "e8fa87f3a3cf6e9bacda5796029462c31efacc0e9ccd2890d36e5a549321e688" => :mojave
    sha256 "27181dd2e3c4a31c7ec552385d9c4036bb22ae9ac4428d1c52a4c8ccda70ee5a" => :high_sierra
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
  depends_on "python@3.8"
  depends_on "shared-mime-info"
  depends_on "vala"
  depends_on "vte3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
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
