class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.58/gobject-introspection-1.58.0.tar.xz"
  sha256 "27c1590a32749de0a5481ce897772547043e94bccba4bc0a7edb3d8513e401ec"

  bottle do
    sha256 "28c0c311eb0f5d5856629b978e0e4128e694b3ec98ae973cd541dc89b4fbdc13" => :mojave
    sha256 "7e3896225d492382272968eb6eebf0d4fb94e233b1833dc8ef5e2216b846efe0" => :high_sierra
    sha256 "9446ae0d9ea409e8698886e09ddb77f614dd380f00d4aee7189d03067de19adc" => :sierra
    sha256 "4b07786d56ecc06fe369c3dcdbb0462e9ada2741a68d8725256f2826ee80c3fe" => :el_capitan
  end

  depends_on "pkg-config"
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python@2"

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
                          "--with-python=#{Formula["python@2"].opt_bin}/python2"
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
