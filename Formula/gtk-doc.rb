class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz"
  sha256 "1ea46ed400e6501f975acaafea31479cea8f32f911dca4dff036f59e6464fd42"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d62a665def5ac3b9ff47c769b1bf4787c6776da35cf59f2161d7d969e87a032" => :sierra
    sha256 "a9d525c60fdaf4339391d9c22aa4e2bfedc29f3c4eb5c2af7600c1e029961c90" => :el_capitan
    sha256 "2a8c0cfe362660629d19ac91e7150d9460a4a7448fd088000bbea23b93e1498c" => :yosemite
    sha256 "3602498d17e7382bbe3f7a643853b3d80ff009faddcf28e1ea666262f2e4a345" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnome-doc-utils" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2" => "with-python"
  depends_on :perl => "5.18" if MacOS.version <= :mavericks

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
