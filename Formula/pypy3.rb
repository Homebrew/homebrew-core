class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy3-v6.0.0-src.tar.bz2"
  sha256 "ed8005202b46d6fc6831df1d13a4613bc40084bfa42f275068edadf8954034a3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a2da5d37954296140125b0d8b817c546375eeb074fe834bf3d1d933a74b369e0" => :mojave
    sha256 "25f4b9222205b8d951cf54c771e70b0959daefb55bbe84f0c0529251d1f0a3b0" => :high_sierra
    sha256 "2cb646b4b7bfb7b9c9f7381a376143d18e97eb570b2150bd7147b4cb06a5eacd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on :arch => :x86_64
  depends_on "gdbm"
  # pypy does not find system libffi, and its location cannot be given
  # as a build option
  depends_on "libffi" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl"
  depends_on "sqlite"
  depends_on "xz"

  # https://bugs.launchpad.net/ubuntu/+source/gcc-4.2/+bug/187391
  fails_with :gcc_4_2

  # packaging depends on pyparsing
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  # packaging and setuptools depend on six
  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  # setuptools depends on packaging
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
    sha256 "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"
  end

  # setuptools depends on appdirs
  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/72/c2/c09362ab29338413ab687b47dab03bab4a792e2bbb727a1eb5e0a88e3b86/setuptools-39.0.1.zip"
    sha256 "bec7badf0f60e7fc8153fac47836edc41b74e5d541d7692e614e635720d6a7c7"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ae/e8/2340d46ecadb1692a1e455f13f75e596d4eab3d11a57446f08259dee8f02/pip-10.0.1.tar.gz"
    sha256 "f2bd08e0cd1b06e10218feaf6fef299f473ba706582eb3bd9d52203fdbd7ee68"
  end

  def install
    # Work around "dyld: Symbol not found: _utimensat"
    if MacOS.version == :sierra && MacOS::Xcode.installed? && MacOS::Xcode.version >= "9.0"
      ENV.delete("SDKROOT")
    end

    # This has been completely rewritten upstream in master so check with
    # the next release whether this can be removed or not.
    inreplace "pypy/tool/build_cffi_imports.py" do |s|
      s.gsub! "http://", "https://"
      s.gsub! "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.6.2.tar.gz",
              "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.6.2.tar.gz"
      s.gsub! "https://tukaani.org/xz/xz-5.2.3.tar.gz",
              "https://netix.dl.sourceforge.net/project/lzmautils/xz-5.2.3.tar.gz"
      s.gsub! "os.path.join(tempfile.gettempdir(), 'pypy-archives')",
              "os.path.join('#{buildpath}', 'pypy-archives')"
    end

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

    (libexec/"lib").install libexec/"bin/libpypy3-c.dylib" => "libpypy3-c.dylib"

    MachO::Tools.change_install_name("#{libexec}/bin/pypy3",
                                     "@rpath/libpypy3-c.dylib",
                                     "#{libexec}/lib/libpypy3-c.dylib")
    MachO::Tools.change_dylib_id("#{libexec}/lib/libpypy3-c.dylib",
                                 "#{opt_libexec}/lib/libpypy3-c.dylib")

    (libexec/"lib-python").install "lib-python/3"
    libexec.install %w[include lib_pypy]

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy3"
    bin.install_symlink libexec/"bin/pypy" => "pypy3.5"
    lib.install_symlink libexec/"lib/libpypy3-c.dylib"
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
    (distutils+"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[appdirs pyparsing six packaging setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy3", "-s", "setup.py", "install", "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy3 and pip_pypy3
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy3"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy3"

    # post_install happens after linking
    %w[easy_install_pypy3 pip_pypy3].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<~EOS
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
    HOMEBREW_PREFIX+"lib/pypy3/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy3"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/3/distutils"
  end

  test do
    system bin/"pypy3", "-c", "print('Hello, world!')"
    system scripts_folder/"pip", "list"
  end
end
