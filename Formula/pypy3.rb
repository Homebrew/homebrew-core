class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.7-v7.3.7-src.tar.bz2"
  sha256 "2ed02ac9e710859c41bc82deafb08619792bb9a27eeaa1676c741ededd214dd7"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg, branch: "py3.7"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "d5e18214c56907c960277e72b5d1ab9688e42e3323db29e94789ff6e17be3e38"
    sha256 cellar: :any,                 big_sur:      "f4980891d9687298103d5e53f2f783a106d2de25d3b5187da6e11f307a63464d"
    sha256 cellar: :any,                 catalina:     "a42821d5afbdf003b7f5ad607881713b23f3a098eb452d7351ad0c3f28aa42f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e76f45f6f97329af492c51067b6b9e4dc1835fe9a66eaf41e739f213716d5d98"
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on arch: :x86_64
  depends_on "gdbm"
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/1e/5c/3d7b3d91a86d71faf5038c5d259ed36b5d05b7804648e2c43251d574a6e6/setuptools-58.2.0.tar.gz"
    sha256 "2c55bdb85d5bb460bd2e3b12052b677879cffcf46c0c688f2e5bf51d36001145"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/00/5f/d6959d6f25f202e3e68e3a53b815af42d770c829c19382d0acbf2c3e2112/pip-21.3.tar.gz"
    sha256 "741a61baab1dbce2d8ca415effa48a2b6a964564f81a9f4f1fce4c433346c034"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # - Disable building cffi imports with `--embed-dependencies`, which compiles and
  #   statically links a specific OpenSSL version.
  # Upstream issue ref: https://foss.heptapod.net/pypy/pypy/-/issues/3538
  patch :DATA

  def install
    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    inreplace "lib_pypy/_tkinter/tklib_build.py", "/usr/local/opt/tcl-tk/", Formula["tcl-tk"].opt_prefix/""

    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = Formula["pypy"].opt_bin/"pypy"
    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"

      with_env(PYTHONPATH: buildpath) do
        system "./pypy3-c", buildpath/"lib_pypy/pypy_tools/build_cffi_imports.py"
      end
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy3 --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/#{shared_library("libpypy3-c")}" => shared_library("libpypy3-c")

    if OS.mac?
      MachO::Tools.change_install_name("#{libexec}/bin/pypy3",
                                       "@rpath/libpypy3-c.dylib",
                                       "#{libexec}/lib/libpypy3-c.dylib")
      MachO::Tools.change_dylib_id("#{libexec}/lib/libpypy3-c.dylib",
                                   "#{opt_libexec}/lib/libpypy3-c.dylib")
    end

    (libexec/"lib-python").install "lib-python/3"
    libexec.install %w[include lib_pypy]

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy3"
    bin.install_symlink libexec/"bin/pypy" => "pypy3.7"
    lib.install_symlink libexec/"lib/#{shared_library("libpypy3-c")}"

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    if OS.linux?
      rm_f libexec/"bin/libpypy3-c.so.debug"
      rm_f libexec/"bin/pypy3.debug"
    end
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin/"pypy3", "-c", "import #{module_name}"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils/"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy3", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy3 and pip_pypy3
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy3"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy3"

    # post_install happens after linking
    %w[easy_install_pypy3 pip_pypy3].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy3 setup.py install", easy_install_pypy3,
      or pip_pypy3, any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use easy_install_pypy3 and
      pip_pypy3.
      To update pip and setuptools between pypy3 releases, run:
          pip_pypy3 install --upgrade pip setuptools

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX/"lib/pypy3/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX/"share/pypy3"
  end

  # The Cellar location of distutils
  def distutils
    libexec/"lib-python/3/distutils"
  end

  test do
    system bin/"pypy3", "-c", "print('Hello, world!')"
    system bin/"pypy3", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end

__END__
--- a/lib_pypy/_tkinter/tklib_build.py
+++ b/lib_pypy/_tkinter/tklib_build.py
@@ -17,12 +17,12 @@ elif sys.platform == 'win32':
     incdirs = []
     linklibs = ['tcl86t', 'tk86t']
     libdirs = []
-elif sys.platform == 'darwin':
+else:
     # homebrew
     incdirs = ['/usr/local/opt/tcl-tk/include']
     linklibs = ['tcl8.6', 'tk8.6']
     libdirs = ['/usr/local/opt/tcl-tk/lib']
-else:
+if False: # disable Linux system tcl-tk detection
     # On some Linux distributions, the tcl and tk libraries are
     # stored in /usr/include, so we must check this case also
     libdirs = []
--- a/pypy/goal/targetpypystandalone.py
+++ b/pypy/goal/targetpypystandalone.py
@@ -382,7 +382,7 @@ class PyPyTarget(object):
             ''' Use cffi to compile cffi interfaces to modules'''
             filename = join(pypydir, '..', 'lib_pypy', 'pypy_tools',
                                    'build_cffi_imports.py')
-            if sys.platform in ('darwin', 'linux', 'linux2'):
+            if False: # disable building static openssl
                 argv = [filename, '--embed-dependencies']
             else:
                 argv = [filename,]
