class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz"
  sha256 "1ea46ed400e6501f975acaafea31479cea8f32f911dca4dff036f59e6464fd42"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "77cc583a3594d521e4d2a0a7df3e13029c1fe2da1f6a7b5665ef871860699821" => :sierra
    sha256 "35b3d2da573932c1ef5301d3d1fc41cd911602ebc2c48269d95c2c710e1aa6ac" => :el_capitan
    sha256 "35b3d2da573932c1ef5301d3d1fc41cd911602ebc2c48269d95c2c710e1aa6ac" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gnome-doc-utils" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2"
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
