class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy2.7-v7.3.9-src.tar.bz2"
  sha256 "39b0972956f6548ce5828019dbae12503c32d6cbe91a2becf88d3e42cc52197b"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy2(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "f6c5b39e3f421bf25ff90ecb89db4d87193c4780396c9ff453cd665e56141ec2"
    sha256 cellar: :any,                 monterey:     "596f21127b64366a965ac5f5f750d0b923f7b466e2f044c06ad0f7bcd1586659"
    sha256 cellar: :any,                 big_sur:      "860de6d6a144bc37ff5478b19ab284be15f8028268e344928ebfd416b89d5fe5"
    sha256 cellar: :any,                 catalina:     "47cd908fe90ea5d08ef34ad69180c3371aafab7cf6a823a337c6d1f3c89de822"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cee95372f34f80d0491f767ddefc9202ff463c706f931fbf18206317cd5553f6"
  end

  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "gdbm"
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "tcl-tk"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      url "https://downloads.python.org/pypy/pypy2.7-v7.3.4-osx64.tar.bz2"
      sha256 "ee7bf42ce843596521e02c763408a5164d18f23c9617f1b8e032ce0675686582"
    end

    on_linux do
      url "https://downloads.python.org/pypy/pypy2.7-v7.3.4-linux64.tar.bz2"
      sha256 "d3f7b0625e770d9be62201765d7d2316febc463372fba9c93a12969d26ae03dd"
    end
  end

  # > Setuptools as a project continues to support Python 2 with bugfixes and important features on Setuptools 44.x.
  # See https://setuptools.readthedocs.io/en/latest/python%202%20sunset.html#python-2-sunset
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/setuptools-44.1.1.zip"
    sha256 "c67aa55db532a0dadc4d2e20ba9961cbd3ccc84d544e9029699822542b5a476b"
  end

  # > pip 20.3 was the last version of pip that supported Python 2.
  # See https://pip.pypa.io/en/stable/development/release-process/#python-2-support
  resource "pip" do
    url "https://files.pythonhosted.org/packages/53/7f/55721ad0501a9076dbc354cc8c63ffc2d6f1ef360f49ad0fbcce19d68538/pip-20.3.4.tar.gz"
    sha256 "6773934e5f5fc3eaa8c5a44949b5b924fc122daa0a8aa9f80c835b4ca2a543fc"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # - Disable building cffi imports with `--embed-dependencies`, which compiles and
  #   statically links a specific OpenSSL version.
  patch :DATA

  def install
    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    inreplace "lib_pypy/_tkinter/tklib_build.py", "/usr/local/opt/tcl-tk/", Formula["tcl-tk"].opt_prefix/""

    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    resource("bootstrap").stage buildpath/"bootstrap"
    python = buildpath/"bootstrap/bin/pypy"

    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"

      with_env(PYTHONPATH: buildpath) do
        system "./pypy-c", buildpath/"lib_pypy/pypy_tools/build_cffi_imports.py"
      end
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/#{shared_library("libpypy-c")}"
    if OS.mac?
      MachO::Tools.change_install_name("#{libexec}/bin/pypy",
                                       "@rpath/libpypy-c.dylib",
                                       "#{libexec}/lib/libpypy-c.dylib")
    end

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"lib/#{shared_library("libpypy-c")}"

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    if OS.linux?
      rm_f libexec/"bin/libpypy-c.so.debug"
      rm_f libexec/"bin/pypy.debug"
    end
  end

  def post_install
    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    unless (libexec/"site-packages").symlink?
      # fix the case where libexec/site-packages/site-packages was installed
      rm_rf libexec/"site-packages/site-packages"
      mv Dir[libexec/"site-packages/*"], prefix_site_packages
      rm_rf libexec/"site-packages"
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils/"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy setup.py install", easy_install_pypy,
      or pip_pypy, any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use easy_install_pypy and
      pip_pypy.
      To update setuptools and pip between pypy releases, run:
          pip_pypy install --upgrade pip setuptools

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX/"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX/"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec/"lib-python/2.7/distutils"
  end

  test do
    system bin/"pypy", "-c", "print('Hello, world!')"
    system bin/"pypy", "-c", "import time; time.clock()"
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
@@ -354,7 +354,7 @@ class PyPyTarget(object):
             ''' Use cffi to compile cffi interfaces to modules'''
             filename = join(pypydir, '..', 'lib_pypy', 'pypy_tools',
                                    'build_cffi_imports.py')
-            if sys.platform in ('darwin', 'linux', 'linux2'):
+            if False: # disable building static openssl
                 argv = [filename, '--embed-dependencies']
             else:
                 argv = [filename,]
