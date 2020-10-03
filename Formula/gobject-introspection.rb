class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.66/gobject-introspection-1.66.0.tar.xz"
  sha256 "3d66ea3aec7c3f8f1f83d89db3e78e18e36adc22b8bba45298119f0b3ea50060"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url :stable
  end

  bottle do
    sha256 "78481011ce21a280d5803f867c7760ef263306ea32f5a171a38132870b366286" => :catalina
    sha256 "81f0d3fb9f5c11713ca012667ece092e32347307d6e3f759566a1791bcc16bd4" => :mojave
    sha256 "2589ea5a46c0aa38046d9c71ad235027cba380e1e21b39e132a28908ac1cf443" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.8"

  uses_from_macos "flex"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        revision: "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpython=#{Formula["python@3.8"].opt_bin}/python3", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      bin.find { |f| rewrite_shebang detected_python_shebang, f }
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
