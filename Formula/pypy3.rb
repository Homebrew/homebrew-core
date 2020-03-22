class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy3.6-v7.3.0-src.tar.bz2"
  sha256 "48d12c15fbcbcf4a32882a883195e1f922997cde78e7a16d4342b9b521eefcfa"
  head "https://foss.heptapod.net/pypy/pypy", :using => :hg, :branch => "py3.7"

  bottle do
    cellar :any
    sha256 "d1af1b4bbbd226a50df7989c2e5b21d5fb97f0defa7d12a96cd859c595d25c29" => :catalina
    sha256 "da12adec658ce8d292bd9f3ad1766268116f0ef11514e18ec9b1f1551179095d" => :mojave
    sha256 "3e1db4fb3c9e627b285a8d08123513bd5ebe6d351148b7637f9da6a21a3cc111" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on :arch => :x86_64
  depends_on "gdbm"
  # pypy does not find system libffi, and its location cannot be given
  # as a build option
  depends_on "libffi" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  # packaging depends on pyparsing
  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a2/56/0404c03c83cfcca229071d3c921d7d79ed385060bbe969fde3fd8f774ebd/pyparsing-2.4.6.tar.gz"
    sha256 "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f"
  end

  # packaging and setuptools depend on six
  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  # setuptools depends on packaging
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c7/cf/d84b72480a556d9bd4a191a91b0a8ea71cb48e6f6132f12d9d365c51bdb6/packaging-20.0.tar.gz"
    sha256 "fe1d8331dfa7cc0a883b49d75fc76380b2ab2734b220fbb87d774e4fd4b851f8"
  end

  # setuptools depends on appdirs
  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/b0/f3/44da7482ac6da3f36f68e253cb04de37365b3dba9036a3c70773b778b485/setuptools-44.0.0.zip"
    sha256 "e5baf7723e5bb8382fc146e33032b241efc63314211a3a120aaa55d62d2bb008"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ce/ea/9b445176a65ae4ba22dce1d93e4b5fe182f953df71a145f557cffaffc1bf/pip-19.3.1.tar.gz"
    sha256 "21207d76c1031e517668898a6b46a9fb1501c7a4710ef5dfd6a40ad9e6757ea7"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{prefix}/opt/openssl/lib/pkgconfig:#{prefix}/opt/tcl-tk/lib/pkgconfig"
    ENV.prepend "LDFLAGS", "-L#{prefix}/opt/tcl-tk/lib"
    ENV.prepend "CPPFLAGS", "-I#{prefix}/opt/tcl-tk/include"
    # Work around "dyld: Symbol not found: _utimensat"
    ENV.delete("SDKROOT") if MacOS.version == :sierra && MacOS::Xcode.version >= "9.0"

    # Fix build on High Sierra
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "/System/Library/Frameworks/Tk.framework/Versions/Current/Headers/",
              "#{prefix}/opt/tcl-tk/include"
      s.gsub! "libdirs = []",
              "libdirs = ['#{prefix}/opt/tcl-tk/lib']"
    end

    # This has been completely rewritten upstream in master so check with
    # the next release whether this can be removed or not.
    inreplace "pypy/tool/build_cffi_imports.py" do |s|
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
    bin.install_symlink libexec/"bin/pypy" => "pypy3.6"
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

    %w[appdirs six packaging setuptools pyparsing pip].each do |pkg|
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
