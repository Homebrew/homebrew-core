class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 3

  bottle do
    cellar :any
    sha256 "7d4a804d4870770f76675099c50749c9582f739393948b02a71ae72be223eb53" => :mojave
    sha256 "403e577aada95260735e2c8d5764f780cc7f064e2a1916f279845be8cb0342f7" => :high_sierra
    sha256 "3d85551378f74ecbab39ab028dde5e1542fc473a9a9baba3413fa53edfe6f2d5" => :sierra
    sha256 "566425ceba6539e9a40d1024fd036de26ba9d0f81961d556a931208ebfc6abe5" => :el_capitan
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
