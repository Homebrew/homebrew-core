class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.72/glib-2.72.2.tar.xz"
  sha256 "78d599a133dba7fe2036dfa8db8fb6131ab9642783fc9578b07a20995252d2de"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "dd94ffde0318591e91b826353d83387839c57b4455bd79243c7227a2ad83b677"
    sha256 arm64_big_sur:  "d15faebb0bd544559668770ff5ce9b69ce464bd81af81c7d0761c63aacc5cbe6"
    sha256 monterey:       "659c2c285a67d2679c89c039864fa38dc4df64cbfd67bd77ecbeb3f8c701db41"
    sha256 big_sur:        "b747e3542fe204aa1dc1a5892806bdfe0257f7cdfdf0f27d3164742a82e77344"
    sha256 catalina:       "b98e6592d4b92001719c9dd983a76231b352c60915176375a9954c557daf1477"
    sha256 x86_64_linux:   "656c6a4aaa9c2a802e4167b46cccc8ee2dfaed3b33cdcc974a8f35903af0c09a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pcre" => :build
  depends_on "pkg-config" => :build
  depends_on "libglib"
  depends_on "python@3.9"

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Point the headers and libraries to `libglib`.
    # The headers and libraries will be removed later because they are provided by `libglib`.
    libglib = Formula["libglib"]
    args = std_meson_args.delete_if do |arg|
      arg.start_with?("--prefix=", "--includedir=", "--libdir=")
    end
    args += %W[
      --prefix=#{prefix}
      --includedir=#{libglib.opt_include}
      --libdir=#{libglib.opt_lib}
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

      # Skip files already in libglib
      Formula["meson"].opt_libexec.cd do
        system "bin/python3", "-c", pyscript
      end

      system "ninja", "install", "-v"
      rewrite_shebang detected_python_shebang, *bin.children
    end

    bash_completion.install Dir["gio/completion/*"]
  end

  def post_install
    # TODO: remove these symlinks when the libglib migration is done
    libglib = Formula["libglib"]
    include.make_relative_symlink(libglib.opt_include) unless include.exist?
    lib.make_relative_symlink(libglib.opt_lib) unless lib.exist?
  end

  def pyscript
    libglib = Formula["libglib"]
    <<~EOS
      import os
      import pickle as pkl
      from mesonbuild.minstall import load_install_data
      filename = os.path.join('#{buildpath}', 'build', 'meson-private', 'install.dat')
      installdata = load_install_data(filename)
      for attrname in ('data', 'emptydir', 'headers', 'install_scripts', 'install_subdirs', 'man', 'symlinks', 'targets'):
          attr = getattr(installdata, attrname)
          attr[:] = list(filter(lambda data: all('#{libglib.opt_prefix}' not in dataattr
                                                 for dataattr in vars(data).values()
                                                 if isinstance(dataattr, str)),
                                attr))
      with open(filename, mode='wb') as file:
          pkl.dump(installdata, file)
    EOS
  end

  test do
    system "#{bin}/glib-compile-schemas", "--version"
  end
end
