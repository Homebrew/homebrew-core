class GtkChtheme < Formula
  desc "GTK+ 2.0 theme changer GUI"
  homepage "http://plasmasturm.org/code/gtk-chtheme/"
  url "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2"
  sha256 "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"
  revision 3

  bottle do
    cellar :any
    sha256 "6294abe2d8ad07c52cc78c6fd156fba145340c163d4be7d103ce91ef84d2911b" => :catalina
    sha256 "54438d348c8534071e384f17ce9e9e5e784ec9732b64249a996372360edb5f9a" => :mojave
    sha256 "5e3ddc7b15e6d35d857815932e80b39f0abf804c8526cc798f0b3d3d66fe0338" => :high_sierra
    sha256 "5af49da12ab0e1799377eb160cff68283b7a24e0149135603d35810e6c0d7e55" => :sierra
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
