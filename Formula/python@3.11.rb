class PythonAT311 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz"
  sha256 "64424e96e2457abbac899b90f9530985b51eef2905951febd935f0e73414caeb"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.11(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "76b29a26e288bef4a981adbe3b57cb88522ff06ebfff01073cb81e478cb97963"
    sha256 arm64_monterey: "4e968bd8f28aee189bd829c2b9feabeb8c5edd95b949cf327ea2f1f62ac76e66"
    sha256 arm64_big_sur:  "c369bb5798613017b55b3f1ab4b83d8f7a4d0558b2c463ff58ccef66fb099391"
    sha256 ventura:        "43a3417b2df0aa72fcc5f190e03e881903911adfcb88bf94f9365d40fc442ff5"
    sha256 monterey:       "919aeadea2828aad7ccd95538e4db27943f8c1fc3c185e5d19d4afd89b1a79ad"
    sha256 big_sur:        "c2b1aa40dc6dfb1c00b5a8531076f410a56ea45a15feded1cc8467d7dfd21e8a"
    sha256 catalina:       "2a2fcc671502de65a0abd3a0c4811c72d06932db90663d12808cbcc5e1c1c04d"
    sha256 x86_64_linux:   "b9cbd3443baea4eccfdb88dac7a9d83f4a6405ae1474ad136d620b87505b828e"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? only_if: :clt_installed

  depends_on "pkg-config" => :build
  depends_on "mpdecimal"
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "berkeley-db@5"
    depends_on "libnsl"
  end

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6", "bin/pip-3.7", "bin/pip-3.8", "bin/pip-3.9",
              "bin/pip-3.10"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5", "bin/easy_install-3.6",
              "bin/easy_install-3.7", "bin/easy_install-3.8", "bin/easy_install-3.9", "bin/easy_install-3.10"

  # Always update to latest release
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c5/41/247814d8b7a044717164c74080725a6c8f3d2b5fc82b34bd825b617df663/setuptools-65.5.0.tar.gz"
    sha256 "512e5536220e38146176efb833d4a62aa726b7bbff82cfbc8ba9eaa3996e0b17"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/f8/08/7f92782ff571c7c7cb6c5eeb8ebbb1f68cb02bdb24e55c5de4dd9ce98bc3/pip-22.3.tar.gz"
    sha256 "8182aec21dad6c0a49a2a3d121a87cd524b950e0b6092b181625f07ebdde7530"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
  end

  # Modify default sysconfig to match the brew install layout.
  # Remove when a non-patching mechanism is added (https://bugs.python.org/issue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6d2fba8de3159182025237d373a6f4f78b8bd203/python/3.11-sysconfig.diff"
    sha256 "8bfe417c815da4ca2c0a2457ce7ef81bc9dae310e20e4fb36235901ea4be1658"
  end

  # Make bundled distutils look at preferred sysconfig scheme.
  # Remove with Python 3.12.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a1618a5005d0b01d63b720321806820a03432f1a/python/3.10-distutils-scheme.diff"
    sha256 "d1a29b3c9ecf8aecd65e1e54efc42fb1422b2f5d05cba0c747178f4ef8a69683"
  end

  def lib_cellar
    on_macos do
      return frameworks/"Python.framework/Versions"/version.major_minor/"lib/python#{version.major_minor}"
    end
    on_linux do
      return lib/"python#{version.major_minor}"
    end
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{version.major_minor}/site-packages"
  end

  def python3
    bin/"python#{version.major_minor}"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    # Override the auto-detection of libmpdec, which assumes a universal build.
    # This is currently an inreplace due to https://github.com/python/cpython/issues/98557.
    if OS.mac?
      inreplace "configure", "libmpdec_machine=universal",
                "libmpdec_machine=#{ENV["PYTHON_DECIMAL_WITH_MACHINE"] = Hardware::CPU.arm? ? "uint128" : "x64"}"
    end

    # The --enable-optimization and --with-lto flags diverge from what upstream
    # python does for their macOS binary releases. They have chosen not to apply
    # these flags because they want one build that will work across many macOS
    # releases. Homebrew is not so constrained because the bottling
    # infrastructure specializes for each macOS major release.
    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --without-ensurepip
      --enable-loadable-sqlite-extensions
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-optimizations
      --with-system-expat
      --with-system-ffi
      --with-system-libmpdec
      --with-readline=editline
    ]

    if OS.mac?
      # Enabling LTO on Linux makes libpython3.*.a unusable for anyone whose GCC
      # install does not match the one in CI _exactly_ (major and minor version).
      # https://github.com/orgs/Homebrew/discussions/3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-dtrace"
      args << "--with-dbmliborder=ndbm"
    else
      args << "--enable-shared"
      args << "--with-dbmliborder=bdb"
    end

    # Python re-uses flags when building native modules.
    # Since we don't want native modules prioritizing the brew
    # include path, we move them to [C|LD]FLAGS_NODIST.
    # Note: Changing CPPFLAGS causes issues with dbm, so we
    # leave it as-is.
    cflags         = []
    cflags_nodist  = ["-I#{HOMEBREW_PREFIX}/include"]
    ldflags        = []
    ldflags_nodist = ["-L#{HOMEBREW_PREFIX}/lib", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"]
    cppflags       = ["-I#{HOMEBREW_PREFIX}/include"]

    if MacOS.sdk_path_if_needed
      # Help Python's build system (setuptools/pip) to build things on SDK-based systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags  << "-isysroot #{MacOS.sdk_path}"
      ldflags << "-isysroot #{MacOS.sdk_path}"
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # Resolve HOMEBREW_PREFIX in our sysconfig modification.
    inreplace "Lib/sysconfig.py", "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    if OS.linux?
      inreplace "setup.py",
        /do_readline = self.compiler.find_library_file\(self.lib_dirs,\s*readline_lib\)/,
        "do_readline = '#{Formula["libedit"].opt_lib/shared_library("libedit")}'"
    end

    if OS.linux?
      # Python's configure adds the system ncurses include entry to CPPFLAGS
      # when doing curses header check. The check may fail when there exists
      # a 32-bit system ncurses (conflicts with the brewed 64-bit one).
      # See https://github.com/Homebrew/linuxbrew-core/pull/22307#issuecomment-781896552
      # We want our ncurses! Override system ncurses includes!
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS -I/usr/include/ncursesw"',
                             "CPPFLAGS=\"$CPPFLAGS -I#{Formula["ncurses"].opt_include}\""
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
              "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib', '#{Formula["openssl@1.1"].opt_lib}',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "CFLAGS_NODIST=#{cflags_nodist.join(" ")}" unless cflags_nodist.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "LDFLAGS_NODIST=#{ldflags_nodist.join(" ")}" unless ldflags_nodist.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    # Disabled modules - provided in separate formulae
    args += %w[
      py_cv_module__tkinter=disabled
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # The `altinstall` target prevents the installation of files with only Python's major
      # version in its name. This allows us to link multiple versioned Python formulae.
      #   https://github.com/python/cpython#installing-multiple-versions
      #
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "altinstall", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    if OS.mac?
      # Any .app get a " 3" attached, so it does not conflict with python 2.x.
      prefix.glob("*.app") { |app| mv app, app.to_s.sub(/\.app$/, " 3.app") }

      pc_dir = frameworks/"Python.framework/Versions"/version.major_minor/"lib/pkgconfig"
      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib/"pkgconfig").install_symlink pc_dir.children

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar/"_sysconfigdata__darwin_darwin.py",
        lib_cellar/"config-#{version.major_minor}-darwin/Makefile",
        pc_dir/"python-#{version.major_minor}.pc",
        pc_dir/"python-#{version.major_minor}-embed.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar/"config-#{version.major_minor}-darwin/Makefile",
                /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib/"pkgconfig").install_symlink pc_dir.children

      # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
      inreplace lib_cellar/"_sysconfigdata__darwin_darwin.py",
                %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
                "\\1'#{opt_prefix}/Frameworks/\\2'"

      # Remove symlinks that conflict with the main Python formula.
      rm %w[Headers Python Resources Versions/Current].map { |subdir| frameworks/"Python.framework"/subdir }
    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_*linux_x86_64-*.py",
                    lib_cellar/"config*/Makefile",
                    bin/"python#{version.major_minor}-config",
                    lib/"pkgconfig/python-3*.pc"],
                prefix, opt_prefix

      inreplace bin/"python#{version.major_minor}-config",
                'prefix_real=$(installed_prefix "$0")',
                "prefix_real=#{opt_prefix}"

      # Remove symlinks that conflict with the main Python formula.
      rm lib/"libpython3.so"
    end

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree

    # Prepare a wheel of wheel to install later.
    common_pip_args = %w[
      -v
      --no-deps
      --no-binary :all:
      --no-index
      --no-build-isolation
    ]
    whl_build = buildpath/"whl_build"
    system python3, "-m", "venv", whl_build
    resource("wheel").stage do
      system whl_build/"bin/pip3", "install", *common_pip_args, "."
      system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{libexec}",
                                            "."
    end

    # Replace bundled setuptools/pip with our own.
    rm lib_cellar.glob("ensurepip/_bundled/{setuptools,pip}-*.whl")
    %w[setuptools pip].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                              "--wheel-dir=#{lib_cellar}/ensurepip/_bundled",
                                              "."
      end
    end

    # Patch ensurepip to bootstrap our updated versions of setuptools/pip
    inreplace lib_cellar/"ensurepip/__init__.py" do |s|
      s.gsub!(/_SETUPTOOLS_VERSION = .*/, "_SETUPTOOLS_VERSION = \"#{resource("setuptools").version}\"")
      s.gsub!(/_PIP_VERSION = .*/, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Write out sitecustomize.py
    (lib_cellar/"sitecustomize.py").atomic_write(sitecustomize)

    # Install unversioned and major-versioned symlinks in libexec/bin.
    {
      "idle"           => "idle#{version.major_minor}",
      "idle3"          => "idle#{version.major_minor}",
      "pydoc"          => "pydoc#{version.major_minor}",
      "pydoc3"         => "pydoc#{version.major_minor}",
      "python"         => "python#{version.major_minor}",
      "python3"        => "python#{version.major_minor}",
      "python-config"  => "python#{version.major_minor}-config",
      "python3-config" => "python#{version.major_minor}-config",
    }.each do |short_name, long_name|
      (libexec/"bin").install_symlink (bin/long_name).realpath => short_name
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{version.major_minor}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Remove old sitecustomize.py. Now stored in the cellar.
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools[-_.][0-9]*", "#{site_packages}/setuptools"]
    rm_rf Dir["#{site_packages}/distribute[-_.][0-9]*", "#{site_packages}/distribute"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]
    rm_rf Dir["#{site_packages}/wheel[-_.][0-9]*", "#{site_packages}/wheel"]

    system python3, "-m", "ensurepip"

    # Install desired versions of setuptools, pip, wheel using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    bundled = lib_cellar/"ensurepip/_bundled"
    system python3, "-m", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           "--target=#{site_packages}",
           bundled/"setuptools-#{resource("setuptools").version}-py3-none-any.whl",
           bundled/"pip-#{resource("pip").version}-py3-none-any.whl",
           libexec/"wheel-#{resource("wheel").version}-py2.py3-none-any.whl"

    # pip install with --target flag will just place the bin folder into the
    # target, so move its contents into the appropriate location
    mv (site_packages/"bin").children, bin
    rmdir site_packages/"bin"

    rm_rf bin.glob("pip{,3}")
    mv bin/"wheel", bin/"wheel#{version.major_minor}"

    # Install unversioned and major-versioned symlinks in libexec/bin.
    {
      "pip"    => "pip#{version.major_minor}",
      "pip3"   => "pip#{version.major_minor}",
      "wheel"  => "wheel#{version.major_minor}",
      "wheel3" => "wheel#{version.major_minor}",
    }.each do |short_name, long_name|
      (libexec/"bin").install_symlink (bin/long_name).realpath => short_name
    end

    # post_install happens after link
    %W[wheel#{version.major_minor} pip#{version.major_minor}].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end
  end

  def sitecustomize
    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys
      if sys.version_info[:2] != (#{version.major}, #{version.minor}):
          # This can only happen if the user has set the PYTHONPATH to a mismatching site-packages directory.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python #{version.major_minor} but you are running Python ' +
                str(sys.version_info[0]) + '.' + str(sys.version_info[1]) + '!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
                '     You should `unset PYTHONPATH` to fix this.')
      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{version.major_minor}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{version.major_minor}/lib/python#{version.major_minor}/site-packages')
          sys.path = [long_prefix.sub('#{HOMEBREW_PREFIX/"lib/python#{version.major_minor}/site-packages"}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = sys._base_executable = '#{opt_bin}/python#{version.major_minor}'
      if 'PYTHONHOME' not in os.environ:
          cellar_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/')
          if os.path.realpath(sys.base_prefix).startswith('#{rack}'):
              new_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_prefix)
              if sys.prefix == sys.base_prefix:
                  sys.prefix = new_prefix
              sys.base_prefix = new_prefix
          if os.path.realpath(sys.base_exec_prefix).startswith('#{rack}'):
              new_exec_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_exec_prefix)
              if sys.exec_prefix == sys.base_exec_prefix:
                  sys.exec_prefix = new_exec_prefix
              sys.base_exec_prefix = new_exec_prefix
      # Check for and add the prefix of split Python formulae.
      for split_module in ["tk", "gdbm"]:
          split_prefix = f"#{HOMEBREW_PREFIX}/opt/python-{split_module}@#{version.major_minor}/libexec"
          if os.path.isdir(split_prefix):
              sys.path.append(split_prefix)
    EOS
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}/bin/python#{version.major_minor}

      Unversioned and major-versioned symlinks `python`, `python3`, `python-config`, `python3-config`, `pip`, `pip3`, etc. pointing to
      `python#{version.major_minor}`, `python#{version.major_minor}-config`, `pip#{version.major_minor}` etc., respectively, have been installed into
        #{opt_libexec}/bin

      If you do not need a specific version of Python, and always want Homebrew's `python3` in your PATH:
        brew install python3

      You can install Python packages with
        pip#{version.major_minor} install <package>
      They will install into the site-package directory
        #{HOMEBREW_PREFIX}/lib/python#{version.major_minor}/site-packages

      tkinter is no longer included with this formula, but it is available separately:
        brew install python-tk@#{version.major_minor}

      gdbm (`dbm.gnu`) is no longer included in this formula, but it is available separately:
        brew install python-gdbm@#{version.major_minor}
      `dbm.ndbm` changed database backends in Homebrew Python 3.11.
      If you need to read a database from a previous Homebrew Python created via `dbm.ndbm`,
      you'll need to read your database using the older version of Homebrew Python and convert to another format.
      `dbm` still defaults to `dbm.gnu` when it is installed.

      For more information about Homebrew and Python, see: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system python3, "-c", "import sqlite3"

    # check to see if we can create a venv
    system python3, "-m", "venv", testpath/"myvenv"

    # Check if some other modules import. Then the linked libs are working.
    system python3, "-c", "import _ctypes"
    system python3, "-c", "import _decimal"
    system python3, "-c", "import pyexpat"
    system python3, "-c", "import zlib"

    # tkinter is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_tkinter'",
                 shell_output("#{python3} -Sc 'import tkinter' 2>&1", 1)

    # gdbm is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import _gdbm' 2>&1", 1)
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import dbm.gnu' 2>&1", 1)

    # Verify that the selected DBM interface works
    (testpath/"dbm_test.py").write <<~EOS
      import dbm

      with dbm.ndbm.open("test", "c") as db:
          db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
          assert list(db.keys()) == [b"foo \\xbd"]
          assert b"foo \\xbd" in db
          assert db[b"foo \\xbd"] == b"bar \\xbd"
    EOS
    system python3, "dbm_test.py"

    system bin/"pip#{version.major_minor}", "list", "--format=columns"
  end
end
