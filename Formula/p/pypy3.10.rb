class Pypy310 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://github.com/pypy/pypy/archive/refs/tags/release-pypy3.10-v7.3.19.tar.gz"
  sha256 "48648aa0a63f4e5fa30315e06b27999ea7157da68a8d4503ebc4a7ee308b5f66"
  license "MIT"
  head "https://github.com/pypy/pypy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b80a1002fd362e89ae2e3353ce566cd4d0e71a1f2c9fa29c1320a28d925dc630"
    sha256 cellar: :any, arm64_sequoia: "13d02f7c456b3561f313153df622cb3c8291104669bfa10c2c9b99a39c7a701d"
    sha256 cellar: :any, arm64_sonoma:  "8c19c7d138dabdb6e6caca03d190132722ede28c816b02e607cb4f1a89d9bb68"
    sha256 cellar: :any, sonoma:        "d825e5ab5629a4da05ca828ca78288653e5235dca4eaddbd003078a7d11a35d1"
    sha256 cellar: :any, arm64_linux:   "f90b17c54b31bc396034479dadef0461ba7882b109c2c85c55e5dbcd04a6cff1"
    sha256 cellar: :any, x86_64_linux:  "6bb389560952b0632d23c74ee4cc871bb658e30960fbfed02cea97ed4d677a5b"
  end

  # PyPy 3.10 was dropped in 7.3.20 and source tarballs have been removed
  deprecate! date: "2026-06-22", because: :deprecated_upstream
  disable! date: "2026-09-22", because: :deprecated_upstream

  depends_on "pkgconf" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk@8"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # setuptools >= 60 required sysconfig patch
  # See https://github.com/Homebrew/homebrew-core/pull/99892#issuecomment-1108492321
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/75/2bc7bef4d668f9caa9c6ed3f3187989922765403198243040d08d2a52725/setuptools-59.8.0.tar.gz"
    sha256 "09980778aa734c3037a47997f28d6db5ab18bdf2af0e49f719bfc53967fd2e82"
  end

  # always pull the latest pip, https://pypi.org/project/pip/#files
  resource "pip" do
    url "https://files.pythonhosted.org/packages/b7/06/6b1ad0ae8f97d7a0d6f6ad640db10780578999e647a9593512ceb6f06469/pip-23.3.2.tar.gz"
    sha256 "7fd9972f96db22c8077a1ee2691b172c8089b17a5652a44494a9ecb0d78f9149"
  end

  def abi_version
    stable.url[/pypy(\d+\.\d+)/, 1]
  end

  def newest_abi_version?
    self == Formula["pypy3"]
  end

  def install
    # Avoid statically linking to libffi
    inreplace "rpython/rlib/clibffi.py", '"libffi.a"', "\"#{shared_library("libffi")}\""

    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    tcltk = Formula["tcl-tk@8"]
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      # Work around https://github.com/pypy/pypy/issues/3538.
      s.gsub! "elif sys.platform == 'darwin':", "else:"
      s.gsub! "else:\n    # On some Linux distributions",
              "if False: # disable Linux system tcl-tk detection\n    # On some Linux distributions"
      s.gsub! "['/usr/local/opt/tcl-tk/include']", "[]"
      # We moved `tcl-tk` headers to `include/tcl-tk` and versioned TCL 8
      # TODO: upstream this.
      s.gsub! "(homebrew + '/include')", "('#{tcltk.opt_include}/tcl-tk')"
      s.gsub! "(homebrew + '/opt/tcl-tk/lib')", "('#{tcltk.opt_lib}')"
    end

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a /usr/local/lib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python/3/ctypes/macholib/dyld.py" do |f|
        f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib', "
        f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
      end
    end

    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = nil
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = formula_opt_bin("pypy")/"pypy"
    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"

      with_env(PYTHONPATH: buildpath) do
        system "./pypy#{abi_version}-c", buildpath/"lib_pypy/pypy_tools/build_cffi_imports.py"
      end
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy3 --targetdir . --no-make-portable --no-embedded-dependencies]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"
    end

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy#{abi_version}"
    lib.install_symlink libexec/"bin"/shared_library("libpypy#{abi_version}-c")
    include.install_symlink libexec/"include/pypy#{abi_version}"

    if newest_abi_version?
      bin.install_symlink "pypy#{abi_version}" => "pypy3"
      lib.install_symlink shared_library("libpypy#{abi_version}-c") => shared_library("libpypy3-c")
    end

    %w[setuptools pip].each do |package|
      (libexec/"post-install-resources").install resource(package).cached_download => "#{package}.tar.gz"
    end

    return unless OS.linux?

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    rm([libexec/"bin/libpypy#{abi_version}-c.so.debug", libexec/"bin/pypy#{abi_version}.debug"])
  end

  post_install_steps do
    bootstrap_pypy abi_version: "3.10"
  end

  def caveats
    <<~EOS
      A "distutils.cfg" has been written to:
        #{distutils}
      specifying the install-scripts folder as:
        #{scripts_folder}

      If you install Python packages via "pypy#{abi_version} setup.py install" or pip_pypy#{abi_version},
      any provided scripts will go into the install-scripts folder
      above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
      so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use pip_pypy#{abi_version}.
      To update pip and setuptools between pypy#{abi_version} releases, run:
          pip_pypy#{abi_version} install --upgrade pip setuptools

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def site_packages(root)
    root/"lib/pypy#{abi_version}/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX/"share/pypy#{abi_version}"
  end

  # The Cellar location of distutils
  def distutils
    site_packages(libexec).parent/"distutils"
  end

  test do
    newest_pypy3_formula_name = CoreTap.instance
                                       .formula_names
                                       .select { |fn| fn.start_with?("pypy3") }
                                       .max_by { |fn| Version.new(fn[/\d+\.\d+$/]) }

    assert_equal Formula["pypy3"],
                 Formula[newest_pypy3_formula_name],
                 "The `pypy3` symlink needs to be updated!"
    assert_equal abi_version, name[/\d+\.\d+$/]
    system bin/"pypy#{abi_version}", "-c", "print('Hello, world!')"
    system bin/"pypy#{abi_version}", "-c", "import time; time.clock()"
    system scripts_folder/"pip#{abi_version}", "list"
  end
end
