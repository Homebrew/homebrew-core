class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz"
  sha256 "bb9d25a3442ca7511385a7c01b057492095c263784ef31231ffe589d83a96a5a"
  revision 1

  bottle do
    cellar :any
    sha256 "5d0cfd09b590acbb425aac203d351e90d27a9b00ff7a15ba9dfd2a3805a44c4f" => :high_sierra
    sha256 "e738e8e735daf77d83d251434fb3dd43b64b5e07b6259dc1d8fd7db1c6c85ea8" => :sierra
    sha256 "f5fcee187ce5ebdedf6c023b8f5fa474df263e1ce2854de8d968540c89648b31" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python"

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
    system "python", "-c", "import dsextras"
  end
end
