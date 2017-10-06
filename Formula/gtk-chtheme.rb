class GtkChtheme < Formula
  desc "GTK+ 2.0 theme changer GUI"
  homepage "http://plasmasturm.org/code/gtk-chtheme/"
  url "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2"
  sha256 "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"
  revision 1

  bottle do
    cellar :any
    sha256 "0c228f7f5b8cfcc95556443db4acea3bd763b99a30a9108bd0eb68ad228838ca" => :high_sierra
    sha256 "913c9417ea21ecebdaeefb0329178d0304530310e4cfe64bf8831da5510bad4b" => :sierra
    sha256 "dc5fb21e189707e3bbc2bea4ac6e8d2091961bae4ea5c593ad2ff7272c5709e6" => :el_capitan
    sha256 "bdda9f20a50734e3ed0802fd12062160dfa378c47a09affb7a4716b892e70afe" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    # Unfortunately chtheme relies on some deprecated functionality
    # we need to disable errors for it to compile properly
    inreplace "Makefile", "-DGTK_DISABLE_DEPRECATED", ""

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # package contains just an executable and a man file
    # executable accepts no options and just spawns a GUI
    assert_predicate bin/"gtk-chtheme", :exist?
  end
end
