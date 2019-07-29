class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.60/gobject-introspection-1.60.2.tar.xz"
  sha256 "ffdfe2368fb2e34a547898b01aac0520d52d8627fdeb1c306559bcb503ab5e9c"
  revision 1

  bottle do
    sha256 "aebf18135464982195e0f14d8a5fd76dd03ef91fa45e3648500576228aec97fc" => :mojave
    sha256 "ab5bff1ce824a2621d7f90296e84499f80275e9370955231ea9de5ff574c2ecf" => :high_sierra
    sha256 "dcd2ffc04732cd3e60e8f1de914838492d1f37d07d8bb26201fd0c25b634cbc3" => :sierra
  end

  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python"].opt_bin}/python3"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
