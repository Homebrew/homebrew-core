class Pypy310 < Formula
  desc "Implementation of Python 3 in Python"
  homepage "https://pypy.org/"
  url "https://downloads.python.org/pypy/pypy3.10-v7.3.13-src.tar.bz2"
  sha256 "4ac1733c19d014d3193c804e7f40ffccbf6924bcaaee1b6089b82b9bf9353a6d"
  license "MIT"
  head "https://foss.heptapod.net/pypy/pypy", using: :hg, branch: "py3.10"

  livecheck do
    url "https://downloads.python.org/pypy/"
    regex(/href=.*?pypy3(?:\.\d+)*[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82ff0d22599bbf07dfb7546c5887dbe5afcac126521ae71097921272f043355c"
    sha256 cellar: :any,                 arm64_ventura:  "e71004f94415dc2985c95bb8f1a0b9b9ba3fbf7ff805546f24ac39ddf250c60f"
    sha256 cellar: :any,                 arm64_monterey: "ae317e5136d996242da542a9294c403abf9d442b7af3f055a72a6b49fef97fb1"
    sha256 cellar: :any,                 sonoma:         "608ad6cf037d3bc5e38c6c1ea0076414f05fd71c7cd493cefa631175269ad87b"
    sha256 cellar: :any,                 ventura:        "df239c85d864cedfd0bda09cc9dc346fba571f682eb863ea8f069deeb83af343"
    sha256 cellar: :any,                 monterey:       "c91904344c75dddeb77a2c2230526a6f5d2865216f6b3b573f1d54e8efe5fb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd6897c538151dbca8233cb9af76286f8587a8b49a52cf28a604b1c94e2ac64"
  end

  depends_on "pkg-config" => :build
  depends_on "pypy" => :build
  depends_on "gdbm"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  # setuptools >= 60 required sysconfig patch
  # See https://github.com/Homebrew/homebrew-core/pull/99892#issuecomment-1108492321
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/75/2bc7bef4d668f9caa9c6ed3f3187989922765403198243040d08d2a52725/setuptools-59.8.0.tar.gz"
    sha256 "09980778aa734c3037a47997f28d6db5ab18bdf2af0e49f719bfc53967fd2e82"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ba/19/e63fb4e0d20e48bd2167bb7e857abc0e21679e24805ba921a224df8977c0/pip-23.2.1.tar.gz"
    sha256 "fb0bd5435b3200c602b5bf61d2d43c2f13c02e29c1707567ae7fbc514eb9faf2"
  end

  # Build fixes:
  # - Disable Linux tcl-tk detection since the build script only searches system paths.
  #   When tcl-tk is not found, it uses unversioned `-ltcl -ltk`, which breaks build.
  # Upstream issue ref: https://foss.heptapod.net/pypy/pypy/-/issues/3538
  patch :DATA

  def abi_version
    stable.url[/pypy(\d+\.\d+)/, 1]
  end

  def newest_abi_version?
    self == Formula["pypy3"]
  end

  def install
    # The `tcl-tk` library paths are hardcoded and need to be modified for non-/usr/local prefix
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "/usr/local/opt/tcl-tk/", Formula["tcl-tk"].opt_prefix/""
      # We moved `tcl-tk` headers to `include/tcl-tk`.
      # TODO: upstream this.
      s.gsub! "/include'", "/include/tcl-tk'"
    end

    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = nil
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = Formula["pypy"].opt_bin/"pypy"
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

    return unless OS.linux?

    # Delete two files shipped which we do not want to deliver
    # These files make patchelf fail
    rm_f [libexec/"bin/libpypy#{abi_version}-c.so.debug", libexec/"bin/pypy#{abi_version}.debug"]
  end

  def post_install
    # Precompile cffi extensions in lib_pypy
    # list from create_cffi_import_libraries in pypy/tool/release/package.py
    %w[_sqlite3 _curses syslog gdbm _tkinter].each do |module_name|
      quiet_system bin/"pypy#{abi_version}", "-c", "import #{module_name}"
    end

    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    site_packages(HOMEBREW_PREFIX).mkpath
    touch site_packages(HOMEBREW_PREFIX)/".keepme"
    site_packages(libexec).rmtree

    # Symlink the prefix site-packages into the cellar.
    site_packages(libexec).parent.install_symlink site_packages(HOMEBREW_PREFIX)

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils/"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy#{abi_version}", "-s", "setup.py", "--no-user-cfg", "install", "--force", "--verbose"
      end
    end

    # Symlinks to pip_pypy3
    bin.install_symlink scripts_folder/"pip#{abi_version}" => "pip_pypy#{abi_version}"
    symlink_to_prefix = [bin/"pip_pypy#{abi_version}"]

    if newest_abi_version?
      bin.install_symlink "pip_pypy#{abi_version}" => "pip_pypy3"
      symlink_to_prefix << (bin/"pip_pypy3")
    end

    # post_install happens after linking
    (HOMEBREW_PREFIX/"bin").install_symlink symlink_to_prefix
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

__END__
--- a/lib_pypy/_tkinter/tklib_build.py
+++ b/lib_pypy/_tkinter/tklib_build.py
@@ -17,7 +17,7 @@ elif sys.platform == 'win32':
     incdirs = []
     linklibs = ['tcl86t', 'tk86t']
     libdirs = []
-elif sys.platform == 'darwin':
+else:
     # homebrew
     homebrew = os.environ.get('HOMEBREW_PREFIX', '')
     incdirs = ['/usr/local/opt/tcl-tk/include']
@@ -26,7 +26,7 @@ elif sys.platform == 'darwin':
     if homebrew:
         incdirs.append(homebrew + '/include')
         libdirs.append(homebrew + '/opt/tcl-tk/lib')
-else:
+if False: # disable Linux system tcl-tk detection
     # On some Linux distributions, the tcl and tk libraries are
     # stored in /usr/include, so we must check this case also
     libdirs = []
