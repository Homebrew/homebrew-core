class Pypy39 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.9-v7.3.11-src.tar.bz2"
  sha256 "b0f3166fb2a5aadfd5ceb9db5cdd5f7929a0eccca02b4a26c0dae0492f7ca8ea"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg, branch: "py3.9"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "libx11"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi" => since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "tcl-tk"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/1e/5c/3d7b3d91a86d71faf5038c5d259ed36b5d05b7804648e2c43251d574a6e6/setuptools-58.2.0.tar.gz"
    sha256 "2c55bdb85d5bb460bd2e3b12052b677879cffcf46c0c688f2e5bf51d36001145"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/a3/50/c4d2727b99052780aad92c7297465af5fe6eec2dbae490aa9763273ffdc1/pip-22.3.1.tar.gz"
    sha256 "65fd48317359f3af8e593943e6ae1506b66325085ea64b706a998c6e83eeaf38"
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
             "-Ojit", "--shared", "--cc", ENV.cc,
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy3 --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/#{shared_library("libpypy3.9-c")}" => shared_library("libpypy3.9-c")

    if OS.mac?
      MachO::Tools.change_install_name("#{libexec}/bin/pypy3.9",
                                       "@rpath/libpypy3.9-c.dylib",
                                       "#{libexec}/lib/libpypy3.9-c.dylib")
      MachO::Tools.change_dylib_id("#{libexec}/lib/libpypy3.9-c.dylib",
                                   "#{opt_libexec}/lib/libpypy3.9-c.dylib")
    end

    (libexec/"lib-python").install "lib-python/3"
    libexec.install %w[include lib_pypy]

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy3.9"
    lib.install_symlink libexec/"lib/#{shared_library("libpypy3.9-c")}"

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    if OS.linux?
      rm_f libexec/"bin/libpypy3.9-c.so.debug"
      rm_f libexec/"bin/pypy3.9.debug"
    end
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm].each do |module_name|
      quiet_system bin/"pypy3.9", "-c", "import #{module_name}"
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
        system bin/"pypy3.9", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy3 and pip_pypy3
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy3.9"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy3.9"

    # post_install happens after linking
    %w[easy_install_pypy3 pip_pypy3].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy3.9 setup.py install", easy_install_pypy3.9,
      or pip_pypy3.9, any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use easy_install_pypy3.9 and
      pip_pypy3.9.
      To update pip and setuptools between pypy3 releases, run:
          pip_pypy3.9 install --upgrade pip setuptools

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
    system bin/"pypy3.9", "-c", "print('Hello, world!')"
    system bin/"pypy3.9", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end
