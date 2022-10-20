class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.74/gobject-introspection-1.74.0.tar.xz"
  sha256 "347b3a719e68ba4c69ff2d57ee2689233ea8c07fc492205e573386779e42d653"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_monterey: "307baaf5210e8e033d3c52a709cdbc1777f89c916717f632d7f16f6efa669595"
    sha256 arm64_big_sur:  "726b08fc6e45ef56842a29a6d1180150c4170392e0fa2bb721bf607bcc37a88d"
    sha256 monterey:       "dcbcbf3257d486fc0691a9b5ff361f0e1b9ddd087665a304d78a7916785a31ca"
    sha256 big_sur:        "0152a1f5af298df65bf2b967f4fae0d6c67a6b68a0cca4f7cf624770f06c13f2"
    sha256 catalina:       "20562281fcf51d765501510a74fb51b40d0b1e7685b0cb177d0d3361609b5388"
    sha256 x86_64_linux:   "9893e569dd50f59ec576feef3d165b26aca9ce9389c699affbd175b1a11de44f"
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
