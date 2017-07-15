class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"
  revision 2

  bottle do
    cellar :any
    sha256 "9a10d979f637cfc9abc46839fa470672ee97a33be5f8ea9a8b725d44f60ed0ba" => :sierra
    sha256 "6fc44a092ad3149c4510db7ed30015b970492974c2926a2ad204a27d3354bb15" => :el_capitan
    sha256 "095cf1af847417ece614fc4b6e2b382a851a97a09b5a48370fdc2fd0bf08b311" => :yosemite
    sha256 "7cc44858e152e843aa0709d5f6d60659f11ac7dbd505379a5f15056ba88d91ae" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/pygobject/patch-enum-types.diff"
    sha256 "99a39c730f9af499db88684e2898a588fdae9cd20eef70675a28c2ddb004cb19"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<-EOS.undent
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system "python", "-c", "import dsextras"
  end
end
