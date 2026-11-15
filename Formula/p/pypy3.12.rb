class Pypy312 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.12-v8.0.1-src.tar.gz"
  sha256 "9d5c82d39d590dc04677f4721738b21d670570cdc9824c003836bafd38556cda"
  license "MIT"
  revision 1

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3\.12[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b60fc781c5db0d801194a7cba1e5e13560fd597e663c2e14132eed313442831"
    sha256 cellar: :any, arm64_tahoe:       "e3c607748e82b07838bb1fe691ff7264874e596bee15aadef20c410d2bb636f4"
    sha256 cellar: :any, arm64_sequoia:     "79e8031412629b175a9685cab2fe51a86791a17331bfe2d95baba81372336c7f"
    sha256 cellar: :any, arm64_linux:       "d4501020fee29afdbbd43d296cb405eacc76e96ac952c67a5c2a18c44919fb78"
    sha256 cellar: :any, x86_64_linux:      "24c46483c77fb72d9a2980df39793ac8f1a8a4e9c70440db36efb744741e0d8e"
  end

  depends_on "pkgconf" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  link_overwrite "bin/pip_pypy3", "bin/pypy3", "lib/libpypy3-c.dylib", "lib/libpypy3-c.so"
  link_overwrite "lib/pypy3.12/site-packages/pip*"

  pypi_packages package_name:   "",
                extra_packages: %w[flit-core pip setuptools]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/fa/e8/0842d757e483e895e670f655084cfe8b8c72580c6769a76b30b2789a0608/pip-26.2.2.tar.gz"
    sha256 "3a8e5c800492787f33a4114ef54444546c340df428974ebba17e0fd47e11af2f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.23-macos_arm64.tar.bz2"
        sha256 "f83d8fce9695f598dc55187c0f6c06c367dbf76d288d2bca7dbf040e4be15f37"
      end
      on_intel do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.23-macos_x86_64.tar.bz2"
        sha256 "edbddb678c00f29c2361dbe6c6ea634f5d62e6854a775a9209c6b789bb0dc00b"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.23-aarch64.tar.bz2"
        sha256 "b0bec20c16b6ab2bd46bd4f5d6049b6070a22a53eaed437ee9ac36d842ceda74"
      end
      on_intel do
        url "https://downloads.python.org/pypy/pypy2.7-v7.3.23-linux64.tar.bz2"
        sha256 "7833be48244a6f4aa0720c6b98f151428291a52697da849ef6b3ca7d5bf45b96"
      end
    end
  end

  deny_network_access!

  def abi_version = stable.url[/pypy(\d+\.\d+)/, 1]

  def newest_abi_version? = self == Formula["pypy3"]

  def site_packages(root) = root/"lib/pypy#{abi_version}/site-packages"

  # Where pip will install executable scripts
  def scripts_folder = HOMEBREW_PREFIX/"share/pypy#{abi_version}"

  def install
    # Avoid statically linking to libffi
    inreplace "rpython/rlib/clibffi.py", '"libffi.a"', "\"#{shared_library("libffi")}\""

    if OS.mac?
      # Allow python modules to use ctypes.find_library to find homebrew's stuff
      # even if homebrew is not a /usr/local/lib. Try this with:
      # `brew install enchant && pip install pyenchant`
      inreplace "lib-python/3/ctypes/macholib/dyld.py" do |s|
        s.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
                "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib', "
        s.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [",
                "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
      end
    end

    ENV["PYPY_USESSION_DIR"] = buildpath
    # TODO: re-enable tkinter when PyPy supports Tcl/Tk 9
    ENV["PYPY_PACKAGE_WITHOUTTK"] = "1"
    inreplace "lib_pypy/pypy_tools/build_cffi_imports.py", '("_tkinter", "_tkinter/tklib_build.py"),', "# \\0"

    resource("bootstrap").stage buildpath/"bootstrap"
    python = buildpath/"bootstrap/bin/pypy"

    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython", "--opt", "jit",
                                                      "--cc", ENV.cc,
                                                      "--make-jobs", ENV.make_jobs,
                                                      "--shared",
                                                      "--verbose"
    end

    # package.py runs `pip install setuptools` for distutils so prep it to avoid
    # network access. This will be installed into the buildpath not the prefix.
    common_pip_args = %w[
      -v
      --no-deps
      --no-binary :all:
      --no-index
      --no-build-isolation
    ]
    resource("setuptools").stage do
      system buildpath/"pypy/goal/pypy#{abi_version}-c", "-m", "pip", "install", *common_pip_args, "."
    end

    system python, "pypy/tool/release/package.py", "--archive-name", "pypy3",
                                                   "--targetdir", ".",
                                                   "--no-embedded-dependencies",
                                                   "--no-keep-debug",
                                                   "--no-make-portable"
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.gz"

    # Prepare virtualenv to build pip wheel
    whl_build = buildpath/"whl_build"
    pypy3 = libexec/"bin/pypy#{abi_version}"
    system pypy3, "-m", "venv", whl_build
    resource("flit-core").stage do
      system whl_build/"bin/pip3", "install", *common_pip_args, "."
    end

    # Replace bundled pip with our own.
    wheel_dir = libexec/"lib/pypy#{abi_version}/ensurepip/_bundled"
    rm wheel_dir.glob("pip-*.whl")
    resource("pip").stage do
      system whl_build/"bin/pip3", "wheel", *common_pip_args, "--wheel-dir=#{wheel_dir}", "."
    end

    # Patch ensurepip to bootstrap our updated version of pip
    inreplace wheel_dir.parent/"__init__.py",
              /_PIP_VERSION = .*/,
              "_PIP_VERSION = \"#{resource("pip").version}\""

    # Ensure that our new pip wheel is globally readable.
    pip_wheel = wheel_dir/"pip-#{resource("pip").version}-py3-none-any.whl"
    chmod "ugo+r", pip_wheel

    # Bootstrap initial install of pip.
    system pypy3, "-Im", "ensurepip"

    # Install desired versions of pip using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    system pypy3, "-Im", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           pip_wheel

    # Move original libexec/bin directory to allow preserving user-installed scripts.
    # Also create symlinks inside pkgshare to allow `brew link/unlink` to work.
    libexec.install libexec/"bin" => "pypybin"
    libexec.install_symlink scripts_folder => "bin"
    pkgshare.install_symlink (libexec/"pypybin").children

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"pypybin/pypy#{abi_version}"
    bin.install_symlink libexec/"pypybin/pip#{abi_version}" => "pip_pypy#{abi_version}"
    lib.install_symlink libexec/"pypybin"/shared_library("libpypy#{abi_version}-c")
    include.install_symlink libexec/"include/pypy#{abi_version}"

    # Symlink site-packages to retain user packages while letting formula maintain pip
    libexec_site_packages = site_packages(libexec)
    site_packages(prefix).parent.install libexec_site_packages
    libexec_site_packages.parent.install_symlink site_packages(HOMEBREW_PREFIX)

    return unless newest_abi_version?

    bin.install_symlink "pip_pypy#{abi_version}" => "pip_pypy3"
    bin.install_symlink "pypy#{abi_version}" => "pypy3"
    lib.install_symlink shared_library("libpypy#{abi_version}-c") => shared_library("libpypy3-c")
  end

  def caveats
    <<~EOS
      tkinter is not provided as it needs end-of-life Tcl/Tk 8.6

      The install-scripts folder is:
        #{scripts_folder}

      If you install Python packages via "pypy#{abi_version} setup.py install" or pip_pypy#{abi_version},
      any provided scripts will go into the install-scripts folder above. You may want to add
      it to your PATH *after* #{HOMEBREW_PREFIX}/bin so you don't overwrite tools from CPython.

      Pip has been installed, so you can use pip_pypy#{abi_version}.
      It is managed by the formula and should not be modified.
    EOS
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
    system bin/"pypy#{abi_version}", "-c", "import time; time.process_time()"
    system scripts_folder/"pip#{abi_version}", "list"
  end
end
