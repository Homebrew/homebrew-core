class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 1

  bottle do
    cellar :any
    sha256 "fcee534090a23fa27136a248d6244b73c37e89a981bced4df6fca3825a07fadd" => :sierra
    sha256 "5cee8a84c58c12daf452fe8ee393df3eb4d64213e32f98aee622d7e51758116f" => :el_capitan
    sha256 "34020ea1db6e802c5b30bcd3cd7062dc34b70e5ca69cbd9d6585868afbe633da" => :yosemite
    sha256 "edcb24f7051defbc49cf0444f38e9dc574c25d12dbe70ba971ee2204818d9419" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtksourceview"
  depends_on "gtk+"
  depends_on "pygtk"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs" # attempts to download chunk.xsl on demand (and sometimes fails)
    system "make", "install"
  end

  test do
    system "python", "-c", "import gtksourceview2"
  end
end
