class GtkChtheme < Formula
  desc "GTK+ 2.0 theme changer GUI"
  homepage "http://plasmasturm.org/code/gtk-chtheme/"
  url "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2"
  sha256 "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"
  revision 2

  bottle do
    cellar :any
    sha256 "757304e1f0c04dcda959f0a001bf6f3011494ded6bcdc085e78d0de6878cbcbf" => :mojave
    sha256 "afdfaeba8db0782720a5cf75e02d47cd2b24f6d25757a555b12770ce977cb013" => :high_sierra
    sha256 "85f27174fb3205ce2552125a4ad269f98d8da600c625aaf88c3c1a788643b714" => :sierra
    sha256 "fe6f305bdd7c48fd8963cba835d0751864d9af7aa994f1957e23838178880347" => :el_capitan
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
