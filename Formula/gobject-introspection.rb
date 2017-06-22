class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.52/gobject-introspection-1.52.1.tar.xz"
  sha256 "2ed0c38d52fe1aa6fc4def0c868fe481cb87b532fc694756b26d6cfab29faff4"

  bottle do
    sha256 "4e73519510f4e86ed98fa1238695b904530fcd5da8334486c85845d75799b050" => :sierra
    sha256 "ef2319e3197b5d157b21151694a7c4b72fa07e093f76ba414a202021a2178bef" => :el_capitan
    sha256 "53525ee2dc4d782627395cd1eafa5e7445c637070488732f37df68eca9f7612e" => :yosemite
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
