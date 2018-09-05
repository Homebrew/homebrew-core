class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz"
  sha256 "bb9d25a3442ca7511385a7c01b057492095c263784ef31231ffe589d83a96a5a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "22913c15bd330f9f1401299a0729330e103c5be2f5da0775d16a99a77ce4f434" => :mojave
    sha256 "c442ae4c5065422f9c522c9e1000dd50f1e9bd565d496cba14a0edb0f378bb6c" => :high_sierra
    sha256 "d483ec396469442c8efb3a0936db2ac3027c131a70c8117f5a1ef6a97a007b00" => :sierra
    sha256 "a1302d922cfb12f36c25ebe6f35438ccb06fe8e7a155d4a9f326f71e8033b644" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python@2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<~EOS
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system Formula["python@2"].opt_bin/"python2.7", "-c", "import dsextras"
  end
end
