class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.3.tar.xz"
  sha256 "c67450f86f9c09c20768f1af36c11a66faf460ea00fbba628a9089a6804808d3"

  bottle do
    rebuild 1
    sha256 "18abbf00cd515f2346c10393ff9e5adef3d477c7478578489398efd1fa3337fd" => :high_sierra
    sha256 "02c744417d58dc442de342f0277ca4d320dde285365d5c88d002932cad2538de" => :sierra
    sha256 "8123441a65bd5d45a1baf9a227911a1edeb514240d8c81fa563de5cc756b3fc8" => :el_capitan
    sha256 "378e85b6e1f712c2415430f426a6381e03c692f8e8f72b93a77f94c2e205fe5a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/ghex", "--help"
  end
end
