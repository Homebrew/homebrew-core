class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.64/gobject-introspection-1.64.1.tar.xz"
  sha256 "80beae6728c134521926affff9b2e97125749b38d38744dc901f4010ee3e7fa7"
  revision 2

  bottle do
    sha256 "4715d7cb549501fa75101266f6c49fe656666cb071a6e8f111b08cb3b74a2b15" => :catalina
    sha256 "e6f0eacacdda25019941d42dd600c478f22de8c57a8975b2e26c4a5cfb8f367c" => :mojave
    sha256 "b54f973af9b413e20a7b6485315da882f73e623c61f3573325a434d47e5b011a" => :high_sierra
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
