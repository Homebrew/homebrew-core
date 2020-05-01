class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.64/gobject-introspection-1.64.1.tar.xz"
  sha256 "80beae6728c134521926affff9b2e97125749b38d38744dc901f4010ee3e7fa7"
  revision 1

  bottle do
    sha256 "243f6d51f2d9b91ba55a8011edd4a6033e2e60332176cab17c6697fedc5b32ab" => :catalina
    sha256 "848dae21878e2178b8b93730b84633e41fd4fe3163cb51d1fb0c33dbc46511d4" => :mojave
    sha256 "2f102d682211e523586cf519fe6d3be3a874f28942245df0f6ee3841756ea328" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.8"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpython=#{Formula["python@3.8"].opt_bin}/python3", ".."
      Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
