class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 4

  bottle do
    cellar :any
    sha256 "a9f2856e35d5253bcea16aa6760fe6bc250b3f626d894649f4bd7ab54c1193fe" => :catalina
    sha256 "ae2e401de44821e4ef5b3e3120ac5a5f686b760b4d52cfadb835b32ef76186c4" => :mojave
    sha256 "1c08c4751e80ff7c9957de906a6c14331867a8aede0960d5a9c9d341951f1cdb" => :high_sierra
    sha256 "bd2fa334ba5a8767e8153fbfd711bc498c300123407d36a287855195f6349cd1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtksourceview"
  depends_on "pygtk"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs" # attempts to download chunk.xsl on demand (and sometimes fails)
    system "make", "install"
  end

  test do
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    system "python2.7", "-c", "import gtksourceview2"
  end
end
