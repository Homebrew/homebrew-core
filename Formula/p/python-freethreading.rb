class PythonFreethreading < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.0/Python-3.14.0.tgz"
  sha256 "88d2da4eed42fa9a5f42ff58a8bc8988881bd6c547e297e46682c2687638a851"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python"
  end

  bottle do
    sha256 arm64_tahoe:   "df6201bc1169d77cfb491afc7ed747bb5f3776261f2a7699fe624604d8280c5f"
    sha256 arm64_sequoia: "1c787feaca327ae5cc5ff9260900007ec6d26384d7d8efda2ec26c1648110482"
    sha256 arm64_sonoma:  "9ae7d2cc1e3250a0e093772a019623027539c661d4dbf58763e190f1595c41df"
    sha256 tahoe:         "6f733ae57726b2f2b655f8d66b0e369367d4a56a71df1d9484c61d8cd644bf3c"
    sha256 sequoia:       "83767759cd4b5560eea734978d69d44ca59096e8ef0b0bc1925b3827899e81e5"
    sha256 sonoma:        "7cc8ebe54805b234e60c20be6cb9a0e179f3a39141372212f6998cfd08f4435f"
    sha256 arm64_linux:   "1dbd68fbdc696b2bc1e9ad72d6f35e8c6458bae5c5db7f56dbf3daf3b2f9df22"
    sha256 x86_64_linux:  "4662b0788d51cb9e42f7603045f455a024116ce06be9f4cd9afc6a6a4ff9fe95"
  end

  depends_on "pkgconf" => :build
  depends_on "mpdecimal"
  depends_on "openssl@3"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  # not actually used, we just want this installed to ensure there are no conflicts.
  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "expat", since: :sequoia
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "berkeley-db@5"
    depends_on "libnsl"
    depends_on "libtirpc"
  end

  pypi_packages package_name:   "",
                extra_packages: %w[flit-core pip wheel]

  # Always update to latest release
  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/fe/6e/74a3f0179a4a73a53d66ce57fdb4de0080a8baa1de0063de206d6167acc2/pip-25.3.tar.gz"
    sha256 "8d0538dbbd7babbd207f261ed969c65de439f6bc9e5dbd3b3b9a77f25d95f343"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  # Modify default sysconfig to match the brew install layout.
  # Remove when a non-patching mechanism is added (https://bugs.python.org/issue43976).
  # We (ab)use osx_framework_library to exploit pip behaviour to allow --prefix to still work.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/python/3.13-sysconfig.diff"
    sha256 "9f2eae1d08720b06ac3d9ef1999c09388b9db39dfb52687fc261ff820bff20c3"
  end

  def lib_cellar
    on_macos do
      return frameworks/"PythonT.framework/Versions"/version.major_minor/"lib/python#{version.major_minor}t"
    end
    on_linux do
      return lib/"python#{version.major_minor}t"
    end
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{version.major_minor}t/site-packages"
  end

  def python3
    bin/"python#{version.major_minor}t"
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
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-optimizations
      --with-system-expat
      --with-system-libmpdec
      --with-readline=editline
      --disable-gil
    ]

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

    if OS.mac?
      # Enabling LTO on Linux makes libpython3.*.a unusable for anyone whose GCC
      # install does not match the one in CI _exactly_ (major and minor version).
      # https://github.com/orgs/Homebrew/discussions/3734
      args << "--with-lto"
      args << "--enable-framework=#{frameworks}"
      args << "--with-framework-name=PythonT"
      args << "--with-dtrace"
      args << "--with-dbmliborder=ndbm"

      # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
      args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    else
      args << "--enable-shared"
      args << "--with-dbmliborder=bdb"
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [",
              "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib', '#{Formula["openssl@3"].opt_lib}',"
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
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}" if OS.mac?
    end

    if OS.mac?
      # Any .app get a " 3" attached, so it does not conflict with python 2.x.
      prefix.glob("*.app") { |app| mv app, app.to_s.sub(/\.app$/, " 3.app") }

      pc_dir = lib_cellar.parent/"pkgconfig"

      # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
      (lib/"pkgconfig").install_symlink pc_dir.glob("*#{version.major_minor}t*")

      # Prevent third-party packages from building against fragile Cellar paths
      bad_cellar_path_files = [
        lib_cellar/"_sysconfigdata_t_darwin_darwin.py",
        lib_cellar/"config-#{version.major_minor}t-darwin/Makefile",
        pc_dir/"python-#{version.major_minor}t.pc",
        pc_dir/"python-#{version.major_minor}t-embed.pc",
      ]
      inreplace bad_cellar_path_files, prefix, opt_prefix

      # Help third-party packages find the Python framework
      inreplace lib_cellar/"config-#{version.major_minor}t-darwin/Makefile",
                /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
                "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

      # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
      inreplace lib_cellar/"_sysconfigdata_t_darwin_darwin.py",
                %r{('LINKFORSHARED': .*?) (PythonT.framework/Versions/3.\d+/PythonT)'}m,
                "\\1 #{opt_prefix}/Frameworks/\\2'"

    else
      # Prevent third-party packages from building against fragile Cellar paths
      inreplace Dir[lib_cellar/"**/_sysconfigdata_t_*linux_x86_64-*.py",
                    lib_cellar/"config*/Makefile",
                    bin/"python#{version.major_minor}t-config",
                    lib/"pkgconfig/python-3*.pc"],
                prefix, opt_prefix

      inreplace bin/"python#{version.major_minor}t-config",
                'prefix_real=$(installed_prefix "$0")',
                "prefix_real=#{opt_prefix}"
    end

    # Remove the site-packages that Python created in its Cellar.
    rm_r site_packages_cellar.children

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
    %w[flit-core wheel].each do |r|
      resource(r).stage do
        system whl_build/"bin/pip3", "install", *common_pip_args, "."
      end
    end
    resource("wheel").stage do
      system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{libexec}",
                                            "."
    end

    # Replace bundled pip with our own.
    rm lib_cellar.glob("ensurepip/_bundled/pip-*.whl")
    resource("pip").stage do
      system whl_build/"bin/pip3", "wheel", *common_pip_args,
                                            "--wheel-dir=#{lib_cellar}/ensurepip/_bundled",
                                            "."
    end

    # Patch ensurepip to bootstrap our updated version of pip
    inreplace lib_cellar/"ensurepip/__init__.py" do |s|
      s.gsub!(/_PIP_VERSION = .*/, "_PIP_VERSION = \"#{resource("pip").version}\"")
    end

    # Rename idle, pydoc to t variants
    mv bin/"idle#{version.major_minor}", bin/"idle#{version.major_minor}t"
    mv bin/"pydoc#{version.major_minor}", bin/"pydoc#{version.major_minor}t"

    # Remove files that conflict with the main python3 formula
    bin.glob("{idle,pydoc}3").map(&:unlink)
    [bin, lib, lib/"pkgconfig", include].each do |directory|
      (directory.glob("*python*") - directory.glob("*#{version.major_minor}t*")).map(&:unlink)
    end
    rm_r share

    # Bootstrap initial install of pip.
    system python3, "-Im", "ensurepip"

    # Install desired versions of pip, wheel using the version of
    # pip bootstrapped by ensurepip.
    # Note that while we replaced the ensurepip wheels, there's no guarantee
    # ensurepip actually used them, since other existing installations could
    # have been picked up (and we can't pass --ignore-installed).
    root_site_packages = lib/"python#{version.major_minor}t/site-packages"
    bundled = lib_cellar/"ensurepip/_bundled"
    system python3, "-Im", "pip", "install", "-v",
           "--no-deps",
           "--no-index",
           "--upgrade",
           "--isolated",
           "--target=#{root_site_packages}",
           bundled/"pip-#{resource("pip").version}-py3-none-any.whl",
           libexec/"wheel-#{resource("wheel").version}-py3-none-any.whl"

    # pip install with --target flag will just place the bin folder into the
    # target, so move its contents into the appropriate location
    mv (root_site_packages/"bin").children, bin
    rmdir root_site_packages/"bin"

    rm [bin/"pip", bin/"pip3"]
    mv bin/"wheel", bin/"wheel#{version.major_minor}t"
    mv bin/"pip#{version.major_minor}", bin/"pip#{version.major_minor}t"

    if OS.mac?
      # Replace framework site-packages with a symlink to the real one.
      rm_r site_packages_cellar
      site_packages_cellar.parent.install_symlink root_site_packages
    end

    # Write out sitecustomize.py
    (lib_cellar/"sitecustomize.py").atomic_write(sitecustomize)

    # Mark Homebrew python as externally managed: https://peps.python.org/pep-0668/#marking-an-interpreter-as-using-an-external-package-manager
    # Placed after ensurepip since it invokes pip in isolated mode, meaning
    # we can't pass --break-system-packages.
    (lib_cellar/"EXTERNALLY-MANAGED").write <<~INI
      [externally-managed]
      Error=To install Python packages system-wide, try brew install
       xyz, where xyz is the package you are trying to
       install.

       If you wish to install a Python library that isn't in Homebrew,
       use a virtual environment:

         #{python3.basename} -m venv path/to/venv
         source path/to/venv/bin/activate
         #{python3.basename} -m pip install xyz

       If you wish to install a Python application that isn't in Homebrew,
       it may be easiest to use 'pipx install xyz', which will manage a
       virtual environment for you. You can install pipx with

         brew install pipx

       You may restore the old behavior of pip by passing
       the '--break-system-packages' flag to pip, or by adding
       'break-system-packages = true' to your pip.conf file. The latter
       will permanently disable this error.

       If you disable this error, we STRONGLY recommend that you additionally
       pass the '--user' flag to pip, or set 'user = true' in your pip.conf
       file. Failure to do this can result in a broken Homebrew installation.

       Read more about this behavior here: <https://peps.python.org/pep-0668/>
    INI
  end

  def sitecustomize
    <<~PYTHON
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import site
      import sys
      if sys.version_info[:2] != (#{version.major}, #{version.minor}):
          # This can only happen if the user has set the PYTHONPATH to a mismatching site-packages directory.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit(f'Your PYTHONPATH points to a site-packages dir for Python #{version.major_minor} '
               f'but you are running Python {sys.version_info[0]}.{sys.version_info[1]}!\\n'
               f'     PYTHONPATH is currently: "{os.environ["PYTHONPATH"]}"\\n'
               f'     You should `unset PYTHONPATH` to fix this.')
      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{version.major_minor}t/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)
          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/(?:[0-9\\._abrc]+/Frameworks/PythonT\\.framework/Versions/#{version.major_minor}/)?lib/python#{version.major_minor}t/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]
          # Set the sys.executable to use the opt_prefix. Only do this if PYTHONEXECUTABLE is not
          # explicitly set and we are not in a virtualenv:
          if 'PYTHONEXECUTABLE' not in os.environ and sys.prefix == sys.base_prefix:
              sys.executable = sys._base_executable = '#{opt_bin}/python#{version.major_minor}t'
      if 'PYTHONHOME' not in os.environ:
          cellar_prefix = re.compile(r'#{rack}/[0-9\\._abrc]+/')
          if os.path.realpath(sys.base_prefix).startswith('#{rack}'):
              new_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_prefix)
              site.PREFIXES[:] = [new_prefix if x == sys.base_prefix else x for x in site.PREFIXES]
              if sys.prefix == sys.base_prefix:
                  sys.prefix = new_prefix
              sys.base_prefix = new_prefix
          if os.path.realpath(sys.base_exec_prefix).startswith('#{rack}'):
              new_exec_prefix = cellar_prefix.sub('#{opt_prefix}/', sys.base_exec_prefix)
              site.PREFIXES[:] = [new_exec_prefix if x == sys.base_exec_prefix else x for x in site.PREFIXES]
              if sys.exec_prefix == sys.base_exec_prefix:
                  sys.exec_prefix = new_exec_prefix
              sys.base_exec_prefix = new_exec_prefix
      # Make site.getsitepackages() return the HOMEBREW_PREFIX site-packages,
      # but only if we are outside a venv or in one with include-system-site-packages.
      if sys.base_prefix in site.PREFIXES:
          site.PREFIXES.insert(site.PREFIXES.index(sys.base_prefix), '#{HOMEBREW_PREFIX}')
          site.addsitedir('#{site_packages}')
    PYTHON
  end

  def caveats
    <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}/bin/#{python3.basename}

      See: https://docs.brew.sh/Homebrew-and-Python
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
    system python3, "-c", "import readline"
    system python3, "-c", "import zlib"
    system python3, "-c", "import _zstd"

    # tkinter is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_tkinter'",
                 shell_output("#{python3} -Sc 'import tkinter' 2>&1", 1)

    # gdbm is provided in a separate formula
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import _gdbm' 2>&1", 1)
    assert_match "ModuleNotFoundError: No module named '_gdbm'",
                 shell_output("#{python3} -Sc 'import dbm.gnu' 2>&1", 1)

    # Verify that the selected DBM interface works
    (testpath/"dbm_test.py").write <<~PYTHON
      import dbm

      with dbm.ndbm.open("test", "c") as db:
          db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
          assert list(db.keys()) == [b"foo \\xbd"]
          assert b"foo \\xbd" in db
          assert db[b"foo \\xbd"] == b"bar \\xbd"
    PYTHON
    system python3, "dbm_test.py"

    system bin/"pip#{version.major_minor}t", "list", "--format=columns"

    # Verify our sysconfig patches
    sysconfig_path = "import sysconfig; print(sysconfig.get_paths(\"osx_framework_library\")[\"data\"])"
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{python3} -c '#{sysconfig_path}'").strip
    linkforshared_var = "import sysconfig; print(sysconfig.get_config_var(\"LINKFORSHARED\"))"
    assert_match opt_prefix.to_s, shell_output("#{python3} -c '#{linkforshared_var}'") if OS.mac?

    # Check our externally managed marker
    assert_match "If you wish to install a Python library",
                 shell_output("#{python3} -m pip install pip 2>&1", 1)
    assert_equal "False", shell_output("#{python3} -c 'import sys; print(sys._is_gil_enabled())'").chomp
  end
end
