class GlibUtils < Formula
  include Language::Python::Shebang

  desc "Python utilities for GLib"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.72/glib-2.72.2.tar.xz"
  sha256 "78d599a133dba7fe2036dfa8db8fb6131ab9642783fc9578b07a20995252d2de"
  license "LGPL-2.1-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python@3.10"

  def install
    # TODO: This is a workaround for `brew audit --new-formula`.
    #       Use `patch` rather than `inreplace` (see also `glib`).
    # replace several hardcoded paths with homebrew counterparts
    inreplace "gio/xdgmime/xdgmime.c",
              'xdg_data_dirs = "/usr/local/share/:/usr/share/";',
              "xdg_data_dirs = \"#{HOMEBREW_PREFIX}/share/:/usr/local/share/:/usr/share/\";"
    inreplace "glib/gutils.c",
              'data_dirs = "/usr/local/share/:/usr/share/";',
              "data_dirs = \"#{HOMEBREW_PREFIX}/share/:/usr/local/share/:/usr/share/\";"

    # Point the headers and libraries to `glib`.
    # The headers and libraries will be removed later because they are provided by `glib`.
    glib = Formula["glib"]
    args = std_meson_args.delete_if do |arg|
      arg.start_with?("--includedir=", "--libdir=")
    end
    args += %W[
      --includedir=#{glib.opt_include}
      --libdir=#{glib.opt_lib}
    ]

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args += %W[
      --default-library=both
      --localstatedir=#{var}
      -Diconv=auto
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"

      # Skip files already in glib
      Formula["meson"].opt_libexec.cd do
        system "bin/python3", "-c", pyscript
      end
      system "ninja", "install", "-v"
    end

    # Delete non python files because they are provided by `glib`
    python_extension_regex = /\.(py(?:[diwx])?|px[di]|cpython-(?:[23]\d{1,2})[-\w]*\.(so|dylib))$/i
    python_shebang_regex = %r{^#! ?/usr/bin/(?:env )?python(?:[23](?:\.\d{1,2})?)?( |$)}
    shebang_max_length = 28 # the length of "#! /usr/bin/env pythonx.yyy "
    prefix.find do |f|
      next unless f.file?
      next if python_extension_regex.match?(f.basename) || python_shebang_regex.match?(f.read(shebang_max_length))

      f.unlink
    end

    # Delete empty directories
    # Note: We need to traversal the directories in reverse order (i.e. deepest first).
    #       Also, we should put checking emptiness and deletion in a single loop.
    #       `dirs.select(&:empty?).map(&:rmdir)` will not work because it will not delete
    #       directories that only contain empty directories.
    prefix.find.select(&:directory?).reverse_each { |d| d.rmdir if d.empty? }

    rewrite_shebang detected_python_shebang, *bin.children
  end

  def pyscript
    # Remove files already provided in glib from meson's install data
    glib = Formula["glib"]
    <<~EOS
      import os
      import pickle as pkl
      from mesonbuild.minstall import load_install_data
      filename = os.path.join('#{buildpath}', 'build', 'meson-private', 'install.dat')
      installdata = load_install_data(filename)
      for attrname in ('data', 'emptydir', 'headers', 'install_scripts', 'install_subdirs', 'man', 'symlinks', 'targets'):
          attr = getattr(installdata, attrname)
          attr[:] = list(filter(lambda data: all(not dataattr.startswith('#{glib.opt_prefix}')
                                                 for dataattr in vars(data).values()
                                                 if isinstance(dataattr, str)),
                                attr))
      with open(filename, mode='wb') as file:
          pkl.dump(installdata, file)
    EOS
  end

  test do
    system "#{bin}/gdbus-codegen", "--help"
    system "#{bin}/glib-genmarshal", "--help"
    system "#{bin}/glib-genmarshal", "--version"
    system "#{bin}/glib-mkenums", "--help"
    system "#{bin}/glib-mkenums", "--version"
  end
end
