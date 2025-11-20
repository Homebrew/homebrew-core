class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy2.7-v7.3.20-src.tar.bz2"
  sha256 "bf958498445f7bf78338723c8d86bd6711e8792461725d2481df77a9566a3e62"
  license "MIT"
  head "https://github.com/pypy/pypy.git", branch: "main"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy2(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe02ce959245ac0b015c388b1c86a542ae9d873a26c8c577cef72e55141747ed"
    sha256 cellar: :any,                 arm64_sequoia: "46e4b322006b665c0e5d7f5d99dc14ed77456a815c52d3f61fc4bb31cb9ed4ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2eec3f57f8559d7f294bb0bba5f4ccc15481688e7bb08ae9ef55b4424eca489f"
    sha256 cellar: :any,                 arm64_ventura: "3c743dd76590b1f95e0c13bc1448731cbeae3d5dcb3c6aa9c6ef98eb683873e9"
    sha256 cellar: :any,                 sonoma:        "bb2157324648efdf4ac18d98f2222bda06a5cec3864997d5bc83df36784d003f"
    sha256 cellar: :any,                 ventura:       "d734256266802ccafb1555fab97e36f15d48d68de1316efe217a1df638fb567a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db99059aacdb6edfd8bb74e19ed4c495d3acdb5f561572156cf01a9b32164e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c768850fbb4013133edcf053c1d11d3250255f52c2dba0ef2f491e181b06dd"
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
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/pypy/tcl-tk.diff"
    sha256 "d17725c11842d83b5432312348715241b1b402173cd68166620c1b6bd8162fbd"
  end

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
