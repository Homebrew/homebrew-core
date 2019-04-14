class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.60/gobject-introspection-1.60.1.tar.xz"
  sha256 "d844d1499ecd36f3ec8a3573616186d36626ec0c9a7981939e99aa02e9c824b3"

  bottle do
    sha256 "2cf3026bc6369c0a4d2654a2e138cce4bacb5b21637a93c46f9c8818ce27a8f7" => :mojave
    sha256 "d15b36fe6f2735551c8472f5dc2ce7ba1fed3a0a69a863ea59c4a91c77cd4d4e" => :high_sierra
    sha256 "980bda6463b96866750a118d4f1a2afb74d8bcd89c4aa44dbe86c160fb7475db" => :sierra
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
