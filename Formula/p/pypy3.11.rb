class Pypy311 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.11-v7.3.23-src.tar.bz2"
  sha256 "f15c9c41e03f3f7ecc25228c6c67427b8918f21ef2d694215994b1fade20f69b"
  license "MIT"
  revision 2

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3\.11[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c1660e17d7360389844c21e0dd90e40f291c04efc569b0d64cf96e1b89b4110"
    sha256 cellar: :any, arm64_sequoia: "c4e23b23ed712b028f95f63665c161812aa866a09106ff8fc9e6fe1fa0a15fe3"
    sha256 cellar: :any, arm64_sonoma:  "3f599b8f7b09b417fc02650f91c0e1ce11a0973bd67c8492e3c6a87c0e2ff5be"
    sha256 cellar: :any, sonoma:        "8079052ae3bf3c1487087f6525f7e9bbb3f4a3f70b711f1234230747a59c2c9e"
    sha256 cellar: :any, arm64_linux:   "3fb7fd9c301e8b9c916fab38ddd222af014f219b7eddad00b8d81b5f1b36bb46"
    sha256 cellar: :any, x86_64_linux:  "36d4e831a1ccbabe784a220bbbbef72e52484265c2ab4831a86dd87c43196b0c"
  end

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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  link_overwrite "bin/pip_pypy3", "bin/pypy3", "lib/libpypy3-c.dylib", "lib/libpypy3-c.so"
  link_overwrite "lib/pypy3.11/site-packages/pip*", "lib/pypy3.11/site-packages/setuptools*"

  pypi_packages package_name:   "",
                extra_packages: %w[flit-core pip setuptools wheel]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/46/ef/34533186e76c526d9ec17a1ad9a10c7354cbfb20f51583cc36dfe4bdccd0/flit_core-4.0.2.tar.gz"
    sha256 "b6929defd93884b584d7c87829e0e7b5c26ed6be17b0b873979019314aa841c8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ae/15/4500e320e6b101ec3b719ae85b697d9940b6cda672bc555bd6016fc60c6f/pip-26.2.1.tar.gz"
    sha256 "f6ad667e89a1fe78046c8f13232b247200f5258d7828f3f7883d660878e0813f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  patch do
    file "Patches/pypy/tcl-tk.diff"
    type :unofficial
    resolves "https://github.com/pypy/pypy/issues/3538"
  end

  deny_network_access!

  def abi_version = stable.url[/pypy(\d+\.\d+)/, 1]

  def newest_abi_version? = self == Formula["pypy3"]

  def site_packages(root) = root/"lib/pypy#{abi_version}/site-packages"

  # Where setuptools will install executable scripts
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

    python = formula_opt_bin("pypy")/"pypy"
    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython", "--opt", "jit",
                                                      "--cc", ENV.cc,
                                                      "--make-jobs", ENV.make_jobs,
                                                      "--shared",
                                                      "--verbose"
    end

    system python, "pypy/tool/release/package.py", "--archive-name", "pypy3",
                                                   "--targetdir", ".",
                                                   "--no-embedded-dependencies",
                                                   "--no-keep-debug",
                                                   "--no-make-portable"
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy3.tar.bz2"

    # Prepare virtualenv for wheel
    common_pip_args = %w[
      -v
      --no-deps
      --no-binary :all:
      --no-index
      --no-build-isolation
    ]
    whl_build = buildpath/"whl_build"
    pypy3 = libexec/"bin/pypy#{abi_version}"
    system pypy3, "-m", "venv", whl_build
    %w[flit-core packaging wheel].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "install", *common_pip_args, "."
      end
    end

    # Replace bundled setuptools/pip with our own.
    wheel_dir = libexec/"lib/pypy#{abi_version}/ensurepip/_bundled"
    rm wheel_dir.glob("{pip,setuptools}*.whl")
    %w[setuptools pip].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "wheel", *common_pip_args, "--wheel-dir=#{wheel_dir}", "."
      end
    end

    # Patch ensurepip to bootstrap our updated versions of setuptools/pip
    inreplace wheel_dir.parent/"__init__.py" do |s|
      s.gsub!(/_SETUPTOOLS_VERSION = .*/, "_SETUPTOOLS_VERSION = \"#{resource("setuptools").version}\"")
      s.gsub!(/_PIP_VERSION = .*/, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Ensure that our new pip wheel is globally readable.
    pip_wheel = wheel_dir/"pip-#{resource("pip").version}-py3-none-any.whl"
    chmod "ugo+r", pip_wheel

    # Bootstrap initial install of pip.
    system pypy3, "-Im", "ensurepip"

    # Install desired versions of setuptools and pip using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    system pypy3, "-Im", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           wheel_dir/"setuptools-#{resource("setuptools").version}-py3-none-any.whl",
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

    # Symlink site-packages to retain user packages while letting formula maintain pip/setuptools
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
      The install-scripts folder is:
        #{scripts_folder}

      If you install Python packages via "pypy#{abi_version} setup.py install" or pip_pypy#{abi_version},
      any provided scripts will go into the install-scripts folder above. You may want to add
      it to your PATH *after* #{HOMEBREW_PREFIX}/bin so you don't overwrite tools from CPython.

      Setuptools and pip have been installed, so you can use pip_pypy#{abi_version}.
      These are managed by the formula and should not be modified.
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
