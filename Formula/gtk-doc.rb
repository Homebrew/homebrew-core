class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "http://www.gtk.org/gtk-doc/"
  url "https://download.gnome.org/sources/gtk-doc/1.24/gtk-doc-1.24.tar.xz"
  sha256 "b420759ea05c760301bada14e428f1b321f5312f44e10a176d6804822dabb58b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cd47e91b2834ee4b6e6ba33c7ac76897fa1205507fab44728120f783e0ca3178" => :el_capitan
    sha256 "9fdd9481987ef549e4b28e1bf7c8f85b593e092e39b4162eb260cc48c0b3abea" => :yosemite
    sha256 "e7bce97e0b25bae469c86eec2d0f22d17987307077ad613bac9d9fc35917a407" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnome-doc-utils" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "libxml2" => "with-python"

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
    system "#{bin}/gtkdoc-scan", "--module=test"
    system "#{bin}/gtkdoc-mkdb", "--module=test"
  end
end
