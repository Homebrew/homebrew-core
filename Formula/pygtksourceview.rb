class Pygtksourceview < Formula
  desc "Python wrapper for the GtkSourceView widget library"
  homepage "https://projects.gnome.org/gtksourceview/pygtksourceview.html"
  url "https://download.gnome.org/sources/pygtksourceview/2.10/pygtksourceview-2.10.1.tar.bz2"
  sha256 "b4b47c5aeb67a26141cb03663091dfdf5c15c8a8aae4d69c46a6a943ca4c5974"
  revision 2

  bottle do
    cellar :any
    sha256 "2977f3362dde914537ab9e43afb9d248fe59701465d422d9e6d83a2a1b37d1e6" => :sierra
    sha256 "42d3f3836f0a32f68b9537b9b4f6696da118fd3d5e9154b338c9fffb50e77e43" => :el_capitan
    sha256 "a5ad125288cf06f63460588298bd0d20395f0163b8b599f77e470e0567dfbb2c" => :yosemite
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
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", Formula["pygtk"].opt_lib+"python2.7/site-packages/gtk-2.0"
    system "python", "-c", "import gtksourceview2"
  end
end
