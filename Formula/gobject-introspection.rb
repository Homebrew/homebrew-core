class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.72/gobject-introspection-1.72.0.tar.xz"
  sha256 "02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_monterey: "379087244dbb609dbee15ddc275aa9535eb25b6fc7e6d9e4aab3003e1438f723"
    sha256 arm64_big_sur:  "d0a568d159af9be1dd21d1313da8049898345cfb786c658e1f984bb0a35e268b"
    sha256 monterey:       "3b1a002f347c39fc9f28b49be0778ea762da29b7e3fc2e07b813f27cab8ab9c3"
    sha256 big_sur:        "2172d936323ec85c3539ed3c7bf65c99871ffbeaa64c257616e52c09cd0ba8e9"
    sha256 catalina:       "6b9375ec9a2e908f441d98379b5cb1b9094ebfbe0f19d1b7a8e35369dfc99052"
    sha256 x86_64_linux:   "66966a890d732c57022b0e1fc8deac865f60dae59e45a429338c1af9f9b82d78"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.9"

  uses_from_macos "flex" => :build

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

    mkdir "build" do
      system "meson", *std_meson_args,
        "-Dpython=#{Formula["python@3.9"].opt_bin}/python3",
        "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
        ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      rewrite_shebang detected_python_shebang, *bin.children
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
