class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.60/gobject-introspection-1.60.0.tar.xz"
  sha256 "9efe4090cb59717126701e97062e784773f800b8d47af14c4d278ebf194df35d"

  bottle do
    sha256 "adbc39c550b6e87f089ec59b312c81dbd0c547ca38bf16c8bf102973e2193624" => :mojave
    sha256 "0075bcc77c062a7f5e33d06ab8e6058e70c3a67cb71e82ad69126c82c100f86c" => :high_sierra
    sha256 "597f57f061dec016d686f96106d9eb77d8fd9031d0a0c54ad143a1549858d6c2" => :sierra
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
