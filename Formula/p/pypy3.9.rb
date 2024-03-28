class Pypy39 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.9-v7.3.15-src.tar.bz2"
  sha256 "6bb9537d85aa7ad13c0aad2e41ff7fd55080bc9b4d1361b8f502df51db816e18"
  license "MIT"
  head "https://github.com/pypy/pypy.git", branch: "py3.9"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3\.9[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e4036bc99784d5e9a4181ae57b693f06e33d5283725657bdf002544e53b5cf8"
    sha256 cellar: :any,                 arm64_ventura:  "8aa75035593e5a2c27882765190de2f54d4523c7daaadc125bf08b55e7c9ff01"
    sha256 cellar: :any,                 arm64_monterey: "9b2e50fcb4fd4d0a8491b5feddf7bba7d33106c177a346844481d1051c6e9cd9"
    sha256 cellar: :any,                 sonoma:         "a398082a9b2e660e5f3dd56b1fb03b71a029d9ca98e1e73becac711e0b7ec797"
    sha256 cellar: :any,                 ventura:        "0683d35b591f98d6f0a20c3a2cd9e4f6ff1a2ab784fef94fe0c14ce20a99644d"
    sha256 cellar: :any,                 monterey:       "1bd9370f7cb0ecfa8166fac07630edae728592174722fc8c50e008e03c173a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f5def43f60dfdb8281ee17e15b45c8ad483f4d10d061ab8ed82784dcb056a71"
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "pip" do
    url "https://files.pythonhosted.org/packages/94/59/6638090c25e9bc4ce0c42817b5a234e183872a1129735a9330c472cc2056/pip-24.0.tar.gz"
    sha256 "ea9bd1a847e8c5774a5777bb398c19e80bcd4e2aa16a4b301b718fe6f593aba2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # Upstream issue ref: https://github.com/pypy/pypy/issues/3538
  patch :DATA

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
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "/usr/local/opt/tcl-tk/", Formula["tcl-tk"].opt_prefix/""
      # We moved `tcl-tk` headers to `include/tcl-tk`.
      # TODO: upstream this.
      s.gsub! "/include'", "/include/tcl-tk'"
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
    site_packages(libexec).rmtree

    # Symlink the prefix site-packages into the cellar.
    site_packages(libexec).parent.install_symlink site_packages(HOMEBREW_PREFIX)

    # Create a scripts folder in the prefix and symlink it as libexec/bin.
    # This is needed as setuptools' distutils ignores our distutils.cfg.
    # If `brew link` created a symlink for scripts folder, replace it with a directory
    if scripts_folder.symlink?
      scripts_folder.unlink
      scripts_folder.install_symlink pkgshare.children
    else
      scripts_folder.mkpath
    end
    libexec.install_symlink scripts_folder => "bin" unless (libexec/"bin").exist?

    # Tell distutils-based installers where to put scripts
    (distutils/"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

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

__END__
--- a/lib_pypy/_tkinter/tklib_build.py
+++ b/lib_pypy/_tkinter/tklib_build.py
@@ -17,7 +17,7 @@ elif sys.platform == 'win32':
     incdirs = []
     linklibs = ['tcl86t', 'tk86t']
     libdirs = []
-elif sys.platform == 'darwin':
+else:
     # homebrew
     homebrew = os.environ.get('HOMEBREW_PREFIX', '')
     incdirs = ['/usr/local/opt/tcl-tk/include']
@@ -26,7 +26,7 @@ elif sys.platform == 'darwin':
     if homebrew:
         incdirs.append(homebrew + '/include')
         libdirs.append(homebrew + '/opt/tcl-tk/lib')
-else:
+if False: # disable Linux system tcl-tk detection
     # On some Linux distributions, the tcl and tk libraries are
     # stored in /usr/include, so we must check this case also
     libdirs = []
