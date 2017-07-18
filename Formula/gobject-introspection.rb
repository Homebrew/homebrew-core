class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.52/gobject-introspection-1.52.1.tar.xz"
  sha256 "2ed0c38d52fe1aa6fc4def0c868fe481cb87b532fc694756b26d6cfab29faff4"
  revision 1

  bottle do
    sha256 "8d3da994fb5a5db1b0e0714e0eb4da0ef7d2f25a34e81eb3215554d135a90ef0" => :sierra
    sha256 "b5058113da00b8d46a972e4512d8be767d7ca5d5eddc3a63c91ef7b8cd962030" => :el_capitan
    sha256 "8176290610aac389a5196195738073db6764426d815b77605f84d547b4f15f0b" => :yosemite
  end

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  # never switch back to system python!
  # https://github.com/Homebrew/homebrew-core/pull/11464#discussion_r107407934
  depends_on "python"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV["PYTHON"] = Formula["python"].opt_bin/"python2"
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
