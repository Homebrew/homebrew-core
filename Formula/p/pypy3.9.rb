class Pypy39 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.9-v7.3.16-src.tar.bz2"
  sha256 "5b75af3f8e76041e79c1ef5ce22ce63f8bd131733e9302081897d8f650e81843"
  license "MIT"
  revision 1
  head "https://github.com/pypy/pypy.git", branch: "py3.9"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ed01fb6eb45c0578207c4dbf98b0d52331fb00bef1d396642ef09805775c0877"
    sha256 cellar: :any,                 arm64_sonoma:  "01ca079d9a0367c1c9b269d7b0070d3433d90734f9f29d12dc6a6d6928bea184"
    sha256 cellar: :any,                 arm64_ventura: "7093697807420f79bee3f5460e9b299f2af0b5a6c0575f7b0d62818240674c2f"
    sha256 cellar: :any,                 sonoma:        "f7f05f94c024769c30430cf4f6bcd7f2f623a3750f79e1bcc329c0494c37560f"
    sha256 cellar: :any,                 ventura:       "62da1b87b483f0820b1f4e39980bcd4199ac8a9b29622e596841d1128cf4a417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "185a9042e0501b1bab93f7741ff4bada3d5fa288b2c680958c89d2df73238052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93eaacb73d4693cd455999a555fffacc3f718b52b25294ae72aaa7ba358e256"
  end

  # https://doc.pypy.org/en/latest/release-v7.3.17.html#pypy-versions-and-speed-pypy-org
  deprecate! date: "2024-09-04", because: :deprecated_upstream
  disable! date: "2025-09-05", because: :deprecated_upstream

  depends_on "pkgconf" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk@8"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  pypi_packages package_name:   "",
                extra_packages: %w[pip setuptools]

  # setup.py got removed in pip 24.1b1 and above
  resource "pip" do
    url "https://files.pythonhosted.org/packages/94/59/6638090c25e9bc4ce0c42817b5a234e183872a1129735a9330c472cc2056/pip-24.0.tar.gz"
    sha256 "ea9bd1a847e8c5774a5777bb398c19e80bcd4e2aa16a4b301b718fe6f593aba2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6a/21/8fd457d5a979109603e0e460c73177c3a9b6b7abcd136d0146156da95895/setuptools-74.0.0.tar.gz"
    sha256 "a85e96b8be2b906f3e3e789adec6a9323abf79758ecfa3065bd740d81158b11e"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # Upstream issue ref: https://github.com/pypy/pypy/issues/3538
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/pypy/tcl-tk.diff"
    sha256 "d17725c11842d83b5432312348715241b1b402173cd68166620c1b6bd8162fbd"
  end

  def abi_version
    stable.url[/pypy(\d+\.\d+)/, 1]
  end

  def newest_abi_version?
    self == Formula["pypy3"]
  end

  def install
    # Work around build failure with Xcode 15.3
    # _curses_cffi.c:6795:38: error: incompatible function pointer types assigning to
    # 'char *(*)(const char *, ...)' from 'char *(char *, ...)' [-Wincompatible-function-pointer-types]
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    tcltk = Formula["tcl-tk@8"]
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "['/usr/local/opt/tcl-tk/include']", "[]"
      # We moved `tcl-tk` headers to `include/tcl-tk` and versioned TCL 8
      # TODO: upstream this.
      s.gsub! "(homebrew + '/include')", "('#{tcltk.opt_include}/tcl-tk')"
      s.gsub! "(homebrew + '/opt/tcl-tk/lib')", "('#{tcltk.opt_lib}')"
    end

    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = nil
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = Formula["pypy"].opt_bin/"pypy"
    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"

      with_env(PYTHONPATH: buildpath) do
        system "./pypy#{abi_version}-c", buildpath/"lib_pypy/pypy_tools/build_cffi_imports.py"
      end
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy3 --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    # Move original libexec/bin directory to allow preserving user-installed scripts.
    # Also create symlinks inside pkgshare to allow `brew link/unlink` to work.
    libexec.install libexec/"bin" => "pypybin"
    pkgshare.install_symlink (libexec/"pypybin").children

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"pypybin/pypy#{abi_version}"
    lib.install_symlink libexec/"pypybin"/shared_library("libpypy#{abi_version}-c")
    include.install_symlink libexec/"include/pypy#{abi_version}"

    if newest_abi_version?
      bin.install_symlink "pypy#{abi_version}" => "pypy3"
      lib.install_symlink shared_library("libpypy#{abi_version}-c") => shared_library("libpypy3-c")
    end

    return unless OS.linux?

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    rm [libexec/"pypybin/libpypy#{abi_version}-c.so.debug", libexec/"pypybin/pypy#{abi_version}.debug"]
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin/"pypy#{abi_version}", "-c", "import #{module_name}"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    site_packages(HOMEBREW_PREFIX).mkpath
    touch site_packages(HOMEBREW_PREFIX)/".keepme"
    rm_r(site_packages(libexec))

    # Symlink the prefix site-packages into the cellar.
    site_packages(libexec).parent.install_symlink site_packages(HOMEBREW_PREFIX)

    # Create a scripts folder in the prefix and symlink it as libexec/bin.
    # This is needed as setuptools' distutils ignores our distutils.cfg.
    # If `brew link` created a symlink for scripts folder, replace it with a directory
    if scripts_folder.symlink?
      scripts_folder.unlink
      scripts_folder.install_symlink pkgshare.children
    end
    libexec.install_symlink scripts_folder => "bin" unless (libexec/"bin").exist?

    # Tell distutils-based installers where to put scripts
    (distutils/"distutils.cfg").atomic_write <<~INI
      [install]
      install-scripts=#{scripts_folder}
    INI

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy#{abi_version}", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to pip_pypy3
    bin.install_symlink scripts_folder/"pip#{abi_version}" => "pip_pypy#{abi_version}"
    symlink_to_prefix = [bin/"pip_pypy#{abi_version}"]

    if newest_abi_version?
      bin.install_symlink "pip_pypy#{abi_version}" => "pip_pypy3"
      symlink_to_prefix << (bin/"pip_pypy3")
    end

    # post_install happens after linking
    (HOMEBREW_PREFIX/"bin").install_symlink symlink_to_prefix
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy#{abi_version} setup.py install" or pip_pypy#{abi_version},
      any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use pip_pypy#{abi_version}.
      To update pip and setuptools between pypy#{abi_version} releases, run:
          pip_pypy#{abi_version} install --upgrade pip setuptools

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def site_packages(root)
    root/"lib/pypy#{abi_version}/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX/"share/pypy#{abi_version}"
  end

  # The Cellar location of distutils
  def distutils
    site_packages(libexec).parent/"distutils"
  end

  test do
    newest_pypy3_formula_name = CoreTap.instance
                                       .formula_names
                                       .select { |fn| fn.start_with?("pypy3") }
                                       .max_by { |fn| Version.new(fn[/\d+\.\d+$/]) }

    assert_equal Formula["pypy3"],
                 Formula[newest_pypy3_formula_name],
                 "The `pypy3` symlink needs to be updated!"
    assert_equal abi_version, name[/\d+\.\d+$/]
    system bin/"pypy#{abi_version}", "-c", "print('Hello, world!')"
    system bin/"pypy#{abi_version}", "-c", "import time; time.clock()"
    system scripts_folder/"pip#{abi_version}", "list"
  end
end
