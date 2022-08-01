class GlibUtils < Formula
  include Language::Python::Shebang

  desc "Python utilities for GLib"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.72/glib-2.72.3.tar.xz"
  sha256 "4a39a2f624b8512d500d5840173eda7fa85f51c109052eae806acece85d345f0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceda984462487b0c9bb77dc0fdbc8d7642eaf7e55e319cac2eb3327dc3da2977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceda984462487b0c9bb77dc0fdbc8d7642eaf7e55e319cac2eb3327dc3da2977"
    sha256 cellar: :any_skip_relocation, monterey:       "b944e164376801f4f695457b9638fb6da2d330422d8d48b59cb26faaa771cb5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b944e164376801f4f695457b9638fb6da2d330422d8d48b59cb26faaa771cb5b"
    sha256 cellar: :any_skip_relocation, catalina:       "b944e164376801f4f695457b9638fb6da2d330422d8d48b59cb26faaa771cb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8428940a0b3059df1edc89ed5ad6cf13c85f4b9548fa53cdb8980da3e27cde"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python@3.10"

  # Sync this with `glib.rb`
  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

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
