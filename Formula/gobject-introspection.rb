class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.52/gobject-introspection-1.52.0.tar.xz"
  sha256 "9fc6d1ebce5ad98942cb21e2fe8dd67b722dcc01981840632a1b233f7d0e2c1e"
  revision 1

  bottle do
    sha256 "0223d5fa11a8f69c40b37a43cab2a145e39ab47f5c96cb3ca078c4b96410dacc" => :sierra
    sha256 "3019889922715fae0111e549ef0eac5308113beb8bbe5ee3dfdef87e1ca8e964" => :el_capitan
    sha256 "6783bf580823d103b1cb202fb52c3215c1deee656decafa1f86d6f7264f79d4b" => :yosemite
  end

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python" # never switch back to system python!

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV["PYTHON"] = Formula["python"].bin/"python"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert (testpath/"Tut-0.1.typelib").exist?
  end
end
