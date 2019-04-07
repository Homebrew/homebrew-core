class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.60/gobject-introspection-1.60.1.tar.xz"
  sha256 "d844d1499ecd36f3ec8a3573616186d36626ec0c9a7981939e99aa02e9c824b3"

  bottle do
    sha256 "ea7bc2f4589f6aa40d1063428e7d4e85bb6108c478b1df403eb2a6d2b6269858" => :mojave
    sha256 "e1ec2088d85415f11e4ddea309f41c51cb6cf2b343f38b039d05d81c4e8cc8cc" => :high_sierra
    sha256 "5bfcef20b0f999c3428d86e93ae30e7acb954bafb8a0f025e27831144cc1a231" => :sierra
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
