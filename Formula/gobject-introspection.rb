class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.58/gobject-introspection-1.58.2.tar.xz"
  sha256 "2a5e0f69459af7ca4c41b8f4e19d9c80ddf877834bb0e7fdd420e2495ae2eda8"
  revision 1

  bottle do
    sha256 "a6beac9d34408e7c3b2f47fe6c32b5b7ee4b6a0830eed3220c98d5f08a66dfaf" => :mojave
    sha256 "9e1b84d300574888afa48d17e8c141941eadc39b1c152c8ceeb6f3652616b628" => :high_sierra
    sha256 "bfcbdf5408d6990606597bcc32c8b55c6e0d062af30cbf8100cfd200277aece0" => :sierra
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
