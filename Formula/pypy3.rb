class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.7-v7.3.4-src.tar.bz2"
  sha256 "74d3c1e79f3fc7d384ffb32d3d2a95c2d5f61b81091eccce12ac76030d96ad08"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg, branch: "py3.7"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 big_sur:  "5c75fdfbe4b07c5b71710d78c9385588e8e47834668944ddfb8035482e27464b"
    sha256 catalina: "8563d2632d5715059ed80f55072373dbcf300760a1eb0b84606aa61c61c16e8f"
    sha256 mojave:   "9788f01a03f858049a94376dcc657e1e8dd07b40c3e528acfee7f72384de8d2c"
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on arch: :x86_64
  depends_on "gdbm"
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/94/75/05e1d69c61c4dfaf65ad12785cd18bedc1e0129976c55914d6aea59c7da8/setuptools-54.2.0.tar.gz"
    sha256 "aa9c24fb83a9116b8d425e53bec24c7bfdbffc313c2159f9ed036d4a6dd32d7d"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/b7/2d/ad02de84a4c9fd3b1958dc9fb72764de1aa2605a9d7e943837be6ad82337/pip-21.0.1.tar.gz"
    sha256 "99bbde183ec5ec037318e774b0d8ae0a64352fe53b2c7fd630be1d07e94f41e5"
  end

  def install
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
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      system python, "package.py", "--archive-name", "pypy3", "--targetdir", "."
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/#{shared_library("libpypy3-c")}" => shared_library("libpypy3-c")

    on_macos do
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
    on_linux do
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
