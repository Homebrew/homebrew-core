class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.58/gobject-introspection-1.58.2.tar.xz"
  sha256 "2a5e0f69459af7ca4c41b8f4e19d9c80ddf877834bb0e7fdd420e2495ae2eda8"
  revision 1

  bottle do
    sha256 "857e1859bb7d22ffd0df3beb43adda587e3a393d8e632a3550b9282d27e103da" => :mojave
    sha256 "a87158a6cca22cbb1770dfe33813de473e3cc0c675373d4e64b8c7c4f0b7b218" => :high_sierra
    sha256 "99fe55b6f91df27d361c466e7d5722c7cc2b06f4062bb84c338f29eebd147552" => :sierra
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
