class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.58/gobject-introspection-1.58.1.tar.xz"
  sha256 "4954681fa5c5ed95451d914de89de1263a5b35158b1ded1a8b870042c0d0df89"

  bottle do
    sha256 "28c6ae776ec71fb8990660229cb171ecf6e6792873a6fb9f87e9882d6c96dffe" => :mojave
    sha256 "24a45803b455d938c7f2918ba1fd7fec50cb0fbc6af27289a27e0743171251ae" => :high_sierra
    sha256 "d2dbab8c078919411b6c6d8b495a6839634b09bbd41e723157d2a7947cc76d85" => :sierra
    sha256 "dc2f4b80a9239b2b077b59e36f1bf8137200f9133f0714925f3791179cf42edc" => :el_capitan
  end

  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
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
