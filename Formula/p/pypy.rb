class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy2.7-v7.3.19-src.tar.bz2"
  sha256 "8703cdcb01f9f82966dd43b6a6018f140399db51ebb43c125c1f9a215e7bb003"
  license "MIT"
  head "https://github.com/pypy/pypy.git", branch: "main"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy2(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58bb108411e8647d3dd78869113ae11b982b243785136d876c9181a8e1d35132"
    sha256 cellar: :any,                 arm64_sonoma:  "04f649d0679c90024d9c74bada227b201e119d427a30c0221ae1569e5cd78501"
    sha256 cellar: :any,                 arm64_ventura: "bd4c3f56ba5df8881c381dde593ea05084fc2aed6aeaf023700f1e62d84666e1"
    sha256 cellar: :any,                 sonoma:        "731e075bdfe1a731a2f95731def57dc4effc35a9eff413b9710874996d24cc38"
    sha256 cellar: :any,                 ventura:       "1c0d7f23afe5b128b2be5c93af7c22dab16af4c76bd8fac5626050b5223e099c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e428e5396ea79feeedc99e1a753b6af06d7bed608bcf432633c550345158a603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb0b648e17940b5e7c4bbb7f5c04ad0cee9bdfab7f7585a384dedd53c027329"
  end

  depends_on "pkgconf" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk@8"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.11-macos_arm64.tar.bz2"
        sha256 "cc5696ab4f93cd3481c1e4990b5dedd7ba60ac0602fa1890d368889a6c5bf771"
      end
      on_intel do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.11-macos_x86_64.tar.bz2"
        sha256 "56deee9c22640f5686c35b9d64fdb1ce3abd044583e4078f0b171ca2fd2a198e"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.11-aarch64.tar.bz2"
        sha256 "ea924da1defe9325ef760e288b04f984614e405580f5321eb6a5c8f539bd415a"
      end
      on_intel do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.11-linux64.tar.bz2"
        sha256 "ba8ed958a905c0735a4cfff2875c25089954dc020e087d982b0ffa5b9da316cd"
      end
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
  patch :DATA

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://github.com/pypy/pypy/issues/4931
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Avoid statically linking to libffi
    inreplace "rpython/rlib/clibffi.py", '"libffi.a"', "\"#{shared_library("libffi")}\""

    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    tcltk = Formula["tcl-tk@8"]
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "['/usr/local/opt/tcl-tk/include']", "[]"
      s.gsub! "(homebrew + '/include')", "('#{tcltk.opt_include}/tcl-tk')"
      s.gsub! "(homebrew + '/opt/tcl-tk/lib')", "('#{tcltk.opt_lib}')"
    end

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a /usr/local/lib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python/2.7/ctypes/macholib/dyld.py" do |f|
        f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
        f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
      end
    end

    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    resource("bootstrap").stage buildpath/"bootstrap"
    python = buildpath/"bootstrap/bin/pypy"

    cd "pypy/goal" do
      system python, "../../rpython/bin/rpython", "--opt", "jit",
                                                  "--cc", ENV.cc,
                                                  "--make-jobs", ENV.make_jobs,
                                                  "--shared",
                                                  "--verbose"
    end

    system python, "pypy/tool/release/package.py", "--archive-name", "pypy",
                                                   "--targetdir", ".",
                                                   "--no-embedded-dependencies",
                                                   "--no-keep-debug",
                                                   "--no-make-portable"
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.bz2"

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"bin"/shared_library("libpypy-c")
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
      rm_r(libexec/"site-packages/site-packages") if (libexec/"site-packages/site-packages").exist?
      mv Dir[libexec/"site-packages/*"], prefix_site_packages
      rm_r(libexec/"site-packages")
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils/"distutils.cfg").atomic_write <<~INI
      [install]
      install-scripts=#{scripts_folder}
    INI

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
