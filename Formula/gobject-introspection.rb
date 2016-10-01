class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.50/gobject-introspection-1.50.0.tar.xz"
  sha256 "1c6597c666f543c70ef3d7c893ab052968afae620efdc080c36657f4226337c5"

  bottle do
    sha256 "a761110e7da384ef2759aed67c87dadddedd265fc69a11ed28190ba886bddec4" => :sierra
    sha256 "00cdb24c5e74f65800d88ca69b5e49f087ab5ea6d59117a1cd47d81e669c9c0d" => :el_capitan
    sha256 "65d2698a5a28799513d4aaa8d28e5d41a87034fa38ce5b9412af43f1b7a9ecb4" => :yosemite
    sha256 "227e7041931934d9bc54ad74e7c163ea80b287120d79e7e3a664e3819687a26f" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  # System python in Mavericks or below has bug in distutils/sysconfig.py, which breaks the install.
  #    Caught exception: <type 'exceptions.AttributeError'> AttributeError("'NoneType' object has no attribute 'get'",)
  #    > /System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/sysconfig.py(171)customize_compiler()
  depends_on "python" if MacOS.version <= :mavericks

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV.universal_binary if build.universal?
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=python"
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
