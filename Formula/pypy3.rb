class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy3.6-v7.1.0-src.tar.bz2"
  sha256 "faa81f469bb2a7cbd22c64f22d4b4ddc5a1f7c798d43b7919b629b932f9b1c6f"
  revision 1

  bottle do
    cellar :any
    sha256 "d84192d75138a909a590edba538e5887325489bf1d882ece92618316cec06c9c" => :mojave
    sha256 "572e61330699307ab49d425f9683e90e226325ddd3b2107857c1b92026c9307e" => :high_sierra
    sha256 "59dbf2859908c30f12904b68caadf5d6b48093d4f51043d8a91d7c15fec28995" => :sierra
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

  # packaging depends on pyparsing
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/b9/b8/6b32b3e84014148dcd60dd05795e35c2e7f4b72f918616c61fdce83d27fc/pyparsing-2.3.1.tar.gz"
    sha256 "66c9268862641abcac4a96ba74506e594c884e3f57690a696d21ad8210ed667a"
  end

  # packaging and setuptools depend on six
  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  # setuptools depends on packaging
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/51/d72654dbbaa4a4ffbf7cb0ecd7d12222979e0a660bf3f42acc47550bf098/packaging-19.0.tar.gz"
    sha256 "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af"
  end

  # setuptools depends on appdirs
  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c2/f7/c7b501b783e5a74cf1768bc174ee4fb0a8a6ee5af6afa92274ff964703e0/setuptools-40.8.0.zip"
    sha256 "6e4eec90337e849ade7103723b9a99631c1f0d19990d6e8412dc42f5ae8b304d"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/36/fa/51ca4d57392e2f69397cd6e5af23da2a8d37884a605f9e3f2d3bfdc48397/pip-19.0.3.tar.gz"
    sha256 "6e6f197a1abfb45118dbb878b5c859a0edbdd33fd250100bc015b67fded4b9f2"
  end

  def install
    ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"

    # Work around "dyld: Symbol not found: _utimensat"
    if MacOS.version == :sierra && MacOS::Xcode.version >= "9.0"
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
