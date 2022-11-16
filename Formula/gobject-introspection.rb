class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.74/gobject-introspection-1.74.0.tar.xz"
  sha256 "347b3a719e68ba4c69ff2d57ee2689233ea8c07fc492205e573386779e42d653"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9342850d655d2ff1ab8d0b263a9cb9eb483fba3f3520754dea86c5db55633d7e"
    sha256 arm64_monterey: "a2d055c6adfe61109d77d6868371a37f757ed2a0215e01e9e6b782af02d2fca8"
    sha256 arm64_big_sur:  "8df914d538a9ee28653ae3a368830481541c13c9fc3bf6133587a86c6d2cc0e4"
    sha256 ventura:        "56cbcedb7b5ff5edc66d039817a85d4dfc80d1861e9db9282e01853ca8a5e328"
    sha256 monterey:       "44b03b7f51941f220e553cbf565e63c7c5e36833609cb6de248d2c62f66d5af3"
    sha256 big_sur:        "60e0831ce9685429b4c7c11180789f225fd30d4542ed102acb912d684383271f"
    sha256 catalina:       "71ad6ca87e733d7a25c43a6a3e5d8d3e2b983d33502e6936dfad0d77b17db6c6"
    sha256 x86_64_linux:   "231554638d60b7702697dbd4266c0104bc2bf19de4f1f9f776e702e5f4b73690"
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
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
