class Pypy3 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.7-v7.3.3-src.tar.bz2"
  sha256 "f6c96401f76331e474cca2d14437eb3b2f68a0f27220a6dcbc537445fe9d5b78"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg, branch: "py3.7"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 "0abe67d4da37ae77c85e8883bcb01ed6b5b8061ad54d4ef9f659b50d9e7a8246" => :catalina
    sha256 "7b80681acba5b237e6a164e3f91dd1d968ebf5b35b60c503d19e4ad3d903147e" => :mojave
    sha256 "022d70ee06728680081e825e1d6737fab2d74d0b51fcc758361a01258423df34" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on arch: :x86_64
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
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  # packaging and setuptools depend on six
  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  # setuptools depends on packaging
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/7c/33ae3aa02eb10ca726b21aa88d338e3f619c674e4fb8544eb352330d880a/packaging-20.7.tar.gz"
    sha256 "05af3bb85d320377db281cf254ab050e1a7ebcbf5410685a9a407e18a1f81236"
  end

  # setuptools depends on appdirs
  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/12/e1/b9a2926a3c5a3fb055b8f85052f5baa890106a0e21b64a977c10affea751/setuptools-51.0.0.zip"
    sha256 "029c49fd713e9230f6a41c0298e6e1f5839f2cde7104c0ad5e053a37777e7688"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/cb/5f/ae1eb8bda1cde4952bd12e468ab8a254c345a0189402bf1421457577f4f3/pip-20.3.1.tar.gz"
    sha256 "43f7d3811f05db95809d39515a5111dd05994965d870178a4fe10d5482f9d2e2"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{prefix}/opt/openssl/lib/pkgconfig:#{prefix}/opt/tcl-tk/lib/pkgconfig"
    ENV.prepend "LDFLAGS", "-L#{prefix}/opt/tcl-tk/lib"
    ENV.prepend "CPPFLAGS", "-I#{prefix}/opt/tcl-tk/include"
    # Work around "dyld: Symbol not found: _utimensat"
    ENV.delete("SDKROOT") if MacOS.version == :sierra && MacOS::Xcode.version >= "9.0"

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
    lib.install_symlink libexec/"lib/#{shared_library("libpypy3-c")}"
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
