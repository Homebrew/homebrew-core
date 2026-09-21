class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy2.7-v8.0.0-src.tar.gz"
  sha256 "e2a56b587014a97a7e6bd14ae99b55247cf2939d67a05a09e62af0afc16125cb"
  license "MIT"
  head "https://github.com/pypy/pypy.git", branch: "main"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy2(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1a9b8421c23abf87f1eb974e3bbac18013d042f7b2ecec89f1075485afa03ecc"
    sha256 cellar: :any, arm64_tahoe:       "55335dba761b5a36705e0a19d8fdd67b0b25d418f275b9c0d385ec92a8f4308c"
    sha256 cellar: :any, arm64_sequoia:     "edcb93d7c3ff8ccb83975f35ccc8d27d801e29c706bd5a2d6a97b10d378e2b72"
    sha256 cellar: :any, arm64_linux:       "bfe7a367b2af89a616b04f653720d0fb72fdcc685f4c3a3dfa0d5d8aa7bf6743"
    sha256 cellar: :any, x86_64_linux:      "7f65b9c1898c96d714bf71b79b87dc30085050399e385af8f1201a549f2c3ccf"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  link_overwrite "lib/pypy/site-packages/README"
  link_overwrite "lib/pypy/site-packages/easy-install.pth"
  link_overwrite "lib/pypy/site-packages/pip*"
  link_overwrite "lib/pypy/site-packages/setuptools*"
  link_overwrite "share/pypy/easy_install*"
  link_overwrite "share/pypy/pip*"

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
    file "Patches/pypy/tcl-tk.diff"
    type :unofficial
    resolves "https://github.com/pypy/pypy/issues/3538"
  end

  # Where setuptools will install executable scripts
  def scripts_folder = HOMEBREW_PREFIX/"share/pypy"

  # The Cellar location of distutils
  def distutils = libexec/"lib-python/2.7/distutils"

  def install
    # Avoid statically linking to libffi
    inreplace "rpython/rlib/clibffi.py", '"libffi.a"', "\"#{shared_library("libffi")}\""

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a /usr/local/lib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python/2.7/ctypes/macholib/dyld.py" do |s|
        s.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
        s.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [",
                "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
      end
    end

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
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.gz"

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system libexec/"bin/pypy", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    bin.install_symlink libexec/"bin/pip" => "pip_pypy"
    bin.install_symlink libexec/"bin/easy_install" => "easy_install_pypy"
    lib.install_symlink libexec/"bin"/shared_library("libpypy-c")
    pkgshare.install_symlink (libexec/"bin").children

    # Symlink the prefix site-packages into the cellar.
    (lib/"pypy").install libexec/"site-packages"
    libexec.install_symlink HOMEBREW_PREFIX/"lib/pypy/site-packages"

    # Tell distutils-based installers where to put scripts
    (distutils/"distutils.cfg").atomic_write <<~INI
      [install]
      install-scripts=#{scripts_folder}
    INI
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
      pip_pypy. These are now managed by the formula and should not be modified.
    EOS
  end

  test do
    system bin/"pypy", "-c", "print('Hello, world!')"
    system bin/"pypy", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end
