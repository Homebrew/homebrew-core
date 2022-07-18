class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.72/gobject-introspection-1.72.0.tar.xz"
  sha256 "02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 1

  bottle do
    sha256 arm64_monterey: "f99f2db1c00cdde18f0cbfa00e70604dfaea7aa512256750eabc31cbb0181204"
    sha256 arm64_big_sur:  "49ce2c6051e3e993326f45e8d29ee9c5ad4827acc7a49f69726e33c4c49e035f"
    sha256 monterey:       "691d417a183544a9b772e10d51c4279d153e3e0261ccfaff592b44099d02d843"
    sha256 big_sur:        "5cb0f78a5c9b1bd0c834b073ad8fffe0349a3b34428244374cb04eef05b88097"
    sha256 catalina:       "aa6e5ba50fc0702af44f8d43539447d1fc8d2a018c41fca919564308d91ae634"
    sha256 x86_64_linux:   "a5fa6b022fa051a18dc59c4bdd92411bc15cfc2bb6c768da5d62dd302ca24974"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"

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
        "-Dpython=#{Formula["python@3.10"].opt_bin}/python3",
        "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
        ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Delete python files because they are provided by `gobject-introspection-utils`
    python_extension_regex = /\.(py(?:[diwx])?|px[di]|cpython-(?:[23]\d{1,2})[-\w]*\.(so|dylib))$/i
    python_shebang_regex = %r{^#! ?/usr/bin/(?:env )?python(?:[23](?:\.\d{1,2})?)?( |$)}
    shebang_max_length = 28 # the length of "#! /usr/bin/env pythonx.yyy "
    prefix.find do |f|
      next unless f.file?

      f.unlink if python_extension_regex.match?(f.basename) || python_shebang_regex.match?(f.read(shebang_max_length))
    end

    rm_rf lib/"gobject-introspection"

    pc_files = %w[
      gobject-introspection-1.0.pc
      gobject-introspection-no-export-1.0.pc
    ]

    pc_files.each do |pc_file|
      inreplace lib/"pkgconfig"/pc_file,
                "g_ir_scanner=${bindir}/g-ir-scanner",
                "g_ir_scanner=#{Formula["gobject-introspection-utils"].opt_bin}/g-ir-scanner"
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    # Build the gobject-introspection test binary but don't build the full tutorial, because it needs g-ir-scanner
    # provided by gobject-introspection-utils, which depends on gobject-introspection.
    pkg_config = Formula["pkg-config"].opt_bin/"pkg-config"
    pkg_config_cflags = Utils.safe_popen_read(pkg_config, "--cflags", "gobject-introspection-1.0").chomp.split
    pkg_config_ldflags = Utils.safe_popen_read(pkg_config, "--libs", "gobject-introspection-1.0",
                                                           "gmodule-2.0").chomp.split
    system ENV.cc, "tut-greeter.c", *pkg_config_cflags, "-c", "-o", "tut-greeter.o"
    system ENV.cc, "main.c", *pkg_config_cflags, "-c", "-o", "main.o"
    system ENV.cc, "tut-greeter.o", "main.o", *pkg_config_ldflags, "-o", "greeter"
    assert_match "Hello, World!", Utils.safe_popen_read(testpath/"greeter")
  end
end
