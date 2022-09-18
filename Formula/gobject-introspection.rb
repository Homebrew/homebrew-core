class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.74/gobject-introspection-1.74.0.tar.xz"
  sha256 "347b3a719e68ba4c69ff2d57ee2689233ea8c07fc492205e573386779e42d653"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_monterey: "976be484265bde8641d3f9f06561d22b17bc4dd060642fe8b871919a026cfb46"
    sha256 arm64_big_sur:  "9a7893449cedf64c11871e59966b9914f54f9d55d57720df70b8d1c9d62c4e6a"
    sha256 monterey:       "9a8e926c80de7098e14449c7f7b54c3a34945ce99c509cbf112302dab569508e"
    sha256 big_sur:        "0d3cf02bd57ca2cd8754dd1326dcec7c559bc9bad831906b8fc510e951223763"
    sha256 catalina:       "d416a917d6cb8aa2dfd00c5eafec6263397f51f85382f70a59b5ae13f203ef48"
    sha256 x86_64_linux:   "027aad7e8d9c0aadfd9bfc0a2b6446a3f797df3e66077388025a34cea0ae2515"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-310-darwin.so`, so needs a specific version.
  depends_on "python@3.10"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        revision: "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{Formula["python@3.10"].opt_bin}/python3.10",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
