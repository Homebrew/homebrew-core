class GobjectIntrospectionUtils < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.72/gobject-introspection-1.72.0.tar.xz"
  sha256 "02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.10"

  uses_from_macos "flex" => :build

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

    # Point the headers and libraries to `gobject-introspection`.
    # The headers and libraries will be removed later because they are provided by `gobject-introspection`.
    gobject_introspection = Formula["gobject-introspection"]
    args = std_meson_args.delete_if do |arg|
      arg.start_with?("--includedir=")
    end
    args += %W[
      --includedir=#{gobject_introspection.opt_include}
      --datadir=#{gobject_introspection.opt_pkgshare}
    ]

    mkdir "build" do
      system "meson", *args,
        "-Dpython=#{Formula["python@3.10"].opt_bin}/python3",
        ".."
      system "ninja", "-v"

      # Skip files already in gobject-introspection.
      Formula["meson"].opt_libexec.cd do
        system "bin/python3", "-c", pyscript
      end
      system "ninja", "install", "-v"
    end

    # Delete most non python files because they are provided by `gobject-introspection`
    python_extension_regex = /\.(py(?:[diwx])?|px[di]|cpython-(?:[23]\d{1,2})[-\w]*\.(so|dylib))$/i
    python_shebang_regex = %r{^#! ?/usr/bin/(?:env )?python(?:[23](?:\.\d{1,2})?)?( |$)}
    shebang_max_length = 28 # the length of "#! /usr/bin/env pythonx.yyy "
    prefix.find do |f|
      next unless f.file?
      next if python_extension_regex.match?(f.basename) || python_shebang_regex.match?(f.read(shebang_max_length))
      next if f.to_s.include?("giscanner") # Don't delete giscanner non-Python files

      f.unlink
    end

    rewrite_shebang detected_python_shebang, *bin.children
  end

  def pyscript
    # Remove files already provided in gobject-introspection from meson's install data
    gobject_introspection = Formula["gobject-introspection"]
    <<~EOS
      import os
      import pickle as pkl
      from mesonbuild.minstall import load_install_data
      filename = os.path.join('#{buildpath}', 'build', 'meson-private', 'install.dat')
      installdata = load_install_data(filename)
      for attrname in ('data', 'emptydir', 'headers', 'install_scripts', 'install_subdirs', 'man', 'symlinks', 'targets'):
          attr = getattr(installdata, attrname)
          attr[:] = list(filter(lambda data: all(not dataattr.startswith('#{gobject_introspection.opt_prefix}')
                                                 for dataattr in vars(data).values()
                                                 if isinstance(dataattr, str)),
                                attr))
      with open(filename, mode='wb') as file:
          pkl.dump(installdata, file)
    EOS
  end

  test do
    # Build full gobject-introspection tutorial which requires both gobject-introspection
    # and gobject-introspection-utils
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    ENV.deparallelize
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end
