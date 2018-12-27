class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.3.tar.xz"
  sha256 "c67450f86f9c09c20768f1af36c11a66faf460ea00fbba628a9089a6804808d3"
  revision 1

  bottle do
    sha256 "baf68c9b93101d0fdb9e90336836d0e206137c59b52e8026d4522d5589a9a0dc" => :mojave
    sha256 "0080cac6bcc11dc849c24bd22a1dda1db0747f523efca1041af9f1e42f029898" => :high_sierra
    sha256 "6f9deaf2bac3fb375bddffe04e43d6eab04c2337aaa7ca08153d97b55208eeaa" => :sierra
    sha256 "7e8089a2904c7864315d8b7eca37dd7df04460d7703a084a0924856fa52383be" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
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
