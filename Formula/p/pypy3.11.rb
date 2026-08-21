class Pypy311 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.11-v7.3.23-src.tar.bz2"
  sha256 "f15c9c41e03f3f7ecc25228c6c67427b8918f21ef2d694215994b1fade20f69b"
  license "MIT"
  revision 1

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3\.11[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b514cd171f5fa038f30daaab338b4ebf1bba30e7505fd714fc4b18eeafe3eeb4"
    sha256 cellar: :any, arm64_sequoia: "d47f809ecf524251e045bc253c1f2e3d7515f767f025270dae2b3651fa399930"
    sha256 cellar: :any, arm64_sonoma:  "b8a3e6b99d1a681cc140a070a3392796dd74387db8f2fa70d7d0263fc4a74005"
    sha256 cellar: :any, sonoma:        "cb9cce87748367b7b24ac46ef41c80eaaa331353f0553b1c1441041c306a66f9"
    sha256 cellar: :any, arm64_linux:   "1f8ea65f8bb78e499efb93f5cd32f677275b7c6d3f0db8c5b2a56589f07739f6"
    sha256 cellar: :any, x86_64_linux:  "1745920536668478e1ae5efcaf39dbf7df0762a15b2cb72c225b3bcfafeb8501"
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
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/01/91/47e7d486260f618783899587af63ccf7980fb60245c3e63dd4571c6b57ad/pip-26.1.2.tar.gz"
    sha256 "f49cd134c61cf2fd75e0ce2676db03e4054504a5a4986d00f8299ae632dc4605"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/39/62/75f18a0f03b4219c456652c7780e4d749b929eb605c098ce3a5b6b6bc081/wheel-0.47.0.tar.gz"
    sha256 "cc72bd1009ba0cf63922e28f94d9d83b920aa2bb28f798a31d0691b02fa3c9b3"
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
