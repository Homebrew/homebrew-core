class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.76/gobject-introspection-1.76.0.tar.xz"
  sha256 "8552ff3a56758b8dba21d421795a52b9a9fbf984565907b83f1c64f4deb8380c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_ventura:  "19eb0afd6372543ecaeba43cfae24e6e2135b1bc27138ab61dc4756eaec521ff"
    sha256 arm64_monterey: "ca6f8c3e9465b40b14a1598c8436f2332d59333da54e76df17ffbbffd399f499"
    sha256 arm64_big_sur:  "35c2a28a8da93cde66a6040815e5eb2ca0d291b3486879e1259982edaacc2129"
    sha256 ventura:        "7a977d115c88b95662932f60d5033a001b74ea8d2f978cffd02c8fdc3e752869"
    sha256 monterey:       "69713b82767990747c2013350e369e408c1e27e19cca94492cb96bcd075f50be"
    sha256 big_sur:        "727cc3e23cc0b1f28eded5c5696a086a6f72e0e8699b66cc7f1d04f034f6b41f"
    sha256 x86_64_linux:   "81dc49f69463e01b17787abf4854326a8e896d652bb846882a5f16195b51cc02"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-311-darwin.so`, so needs a specific version.
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  resource "homebrew-tutorial" do
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
    python3 = "python3.11"

    # Allow scripts to find "python3" during build if Python formula is altinstall'ed
    pyver = Language::Python.major_minor_version python3
    ENV.prepend_path "PATH", Formula["python@#{pyver}"].opt_libexec/"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{which(python3)}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource("homebrew-tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
