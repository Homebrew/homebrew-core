class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.28/anjuta-3.28.0.tar.xz"
  sha256 "b087b0a5857952d0edd24dae458616eb166a3257bc647d5279a9e71495544779"
  revision 2

  bottle do
    sha256 "b55080a83e124784266b42ea56e0f4d3f3b03ca94af6b4ca4a72d9cdc8c1f7e1" => :mojave
    sha256 "e038d342a81ee2f5db084d5ad6d1ff87144194aeae66bef28b3f764b8e0cd6d3" => :high_sierra
    sha256 "d402812770fad67e94aed33484c6ca12cdcd89a4d290e2d313b27f627caeea07" => :sierra
    sha256 "4b5db4d330a8386085efc7cb24771ae7cb49cc3c523c9babb53e177befce9f3b" => :el_capitan
  end

  depends_on "python@2"
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtksourceview3"
  depends_on "libxml2"
  depends_on "libgda"
  depends_on "gdl"
  depends_on "vte3"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"
  depends_on "gnutls"
  depends_on "shared-mime-info"
  depends_on "vala" => :recommended
  depends_on "autogen" => :recommended
  depends_on "gnome-themes-standard" => :optional

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
