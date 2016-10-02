class Python3 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  revision 2

  head "https://hg.python.org/cpython", :using => :hg

  stable do
    url "https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tar.xz"
    sha256 "0010f56100b9b74259ebcd5d4b295a32324b58b517403a10d1a2aa7cb22bca40"

    # Patch for pyport.h macro issue
    # https://bugs.python.org/issue10910
    # https://trac.macports.org/ticket/44288
    patch do
      url "https://bugs.python.org/file30805/issue10910-workaround.txt"
      sha256 "c075353337f9ff3ccf8091693d278782fcdff62c113245d8de43c5c7acc57daf"
    end
  end

  bottle do
    sha256 "848f9ef6f09b2f9e28e4ad29bc2f85d843ae0e2c174f83aedc530b5ba670c704" => :sierra
    sha256 "33300aca2ef4703fb8dfc1a7f6520c2cde6e912f983c3779f8d0d285dade572c" => :el_capitan
    sha256 "3e3cdeaa764bf24ca00d34c3d54b00142de6ae6c1f9e57c014d0a99ea7a583b0" => :yosemite
  end

  devel do
    url "https://www.python.org/ftp/python/3.6.0/Python-3.6.0b1.tar.xz"
    sha256 "a83b094a8abf8a1fba7c548a5e8dd0aabe87a87a6ebd87c97f4a5a2527a74d42"
  end

  option :universal
  option "with-tcl-tk", "Use Homebrew's Tk instead of macOS Tk (has optional Cocoa and threads support)"
  option "with-quicktest", "Run `make quicktest` after the build"
  option "with-sphinx-doc", "Build HTML documentation"

  deprecated_option "quicktest" => "with-quicktest"
  deprecated_option "with-brewed-tk" => "with-tcl-tk"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "gdbm" => :recommended
  depends_on "openssl"
  depends_on "xz" => :recommended # for the lzma module added in 3.3
  depends_on "homebrew/dupes/tcl-tk" => :optional
  depends_on :x11 if build.with?("tcl-tk") && Tab.for_name("homebrew/dupes/tcl-tk").with?("x11")
  depends_on "sphinx-doc" => [:build, :optional]

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9f/32/81c324675725d78e7f6da777483a3453611a427db0145dfb878940469692/setuptools-25.2.0.tar.gz"
    sha256 "b2757ddac2c41173140b111e246d200768f6dd314110e1e40661d0ecf9b4d6a6"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz"
    sha256 "4d24b03ffa67638a3fa931c09fd9e0273ffa904e95ebebe7d4b1a54c93d7b732"
  end

  resource "wheel" do
    url "https://pypi.python.org/packages/source/w/wheel/wheel-0.29.0.tar.gz"
    sha256 "1ebb8ad7e26b448e9caa4773d2357849bf80ff9e313964bcaf79cbf0201a1648"
  end

  fails_with :clang do
    build 425
    cause "https://bugs.python.org/issue24844"
  end

  # Homebrew's tcl-tk is built in a standard unix fashion (due to link errors)
  # so we have to stop python from searching for frameworks and linking against
  # X11.
  patch :DATA if build.with? "tcl-tk"

  def lib_cellar
    prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}"
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
      Could not find platform dependent libraries <exec_prefix>
      Consider setting $PYTHONHOME to <prefix>[:<exec_prefix>]
      python.exe(14122) malloc: *** mmap(size=7310873954244194304) failed (error code=12)
      *** error: can't allocate region
      *** set a breakpoint in malloc_error_break to debug
      Could not import runpy module
      make: *** [pybuilddir.txt] Segmentation fault: 11
    EOS
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<-EOS.undent
    The bottle needs the Apple Command Line Tools to be installed.
      You can install them, if desired, with:
        xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
    ENV.permit_weak_imports

    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
      --without-ensurepip
    ]

    args << "--without-gcc" if ENV.compiler == :clang
    args << "--enable-loadable-sqlite-extensions" if build.with?("sqlite")

    cflags   = []
    ldflags  = []
    cppflags = []

    unless MacOS::CLT.installed?
      # Help Python's build system (setuptools/pip) to build things on Xcode-only systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags   << "-isysroot #{MacOS.sdk_path}"
      ldflags  << "-isysroot #{MacOS.sdk_path}"
      cppflags << "-I#{MacOS.sdk_path}/usr/include" # find zlib
      # For the Xlib.h, Python needs this header dir with the system Tk
      if build.without? "tcl-tk"
        cflags << "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # We want our readline and openssl! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py" do |s|
      s.gsub! "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
              "do_readline = '#{Formula["readline"].opt_lib}/libhistory.dylib'"
      s.gsub! "/usr/local/ssl", Formula["openssl"].opt_prefix
    end

    if build.universal?
      ENV.universal_binary
      args << "--enable-universalsdk" << "--with-universal-archs=intel"
    end

    if build.with? "sqlite"
      inreplace "setup.py" do |s|
        s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
        s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
                "for d_ in ['#{Formula["sqlite"].opt_include}']:"
      end
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    if build.with? "tcl-tk"
      tcl_tk = Formula["tcl-tk"].opt_prefix
      cppflags << "-I#{tcl_tk}/include"
      ldflags  << "-L#{tcl_tk}/lib"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args

    system "make"

    ENV.deparallelize # Installs must be serialized
    # Tell Python not to install into /Applications (default for framework builds)
    system "make", "install", "PYTHONAPPSDIR=#{prefix}"
    # Demos and Tools
    system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}"
    system "make", "quicktest" if build.with? "quicktest"

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob("#{prefix}/*.app") { |app| mv app, app.sub(/\.app$/, " 3.app") }

    # A fix, because python and python3 both want to install Python.framework
    # and therefore we can't link both into HOMEBREW_PREFIX/Frameworks
    # https://github.com/Homebrew/homebrew/issues/15943
    ["Headers", "Python", "Resources"].each { |f| rm(prefix/"Frameworks/Python.framework/#{f}") }
    rm prefix/"Frameworks/Python.framework/Versions/Current"

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir["#{frameworks}/Python.framework/Versions/#{xy}/lib/pkgconfig/*"]

    # Remove 2to3 because python2 also installs it
    rm bin/"2to3"

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree

    # These makevars are available through distutils.sysconfig at runtime and
    # some third-party software packages depend on them
    inreplace Dir.glob(frameworks/"Python.framework/Versions/#{xy}/lib/python#{xy}/config-#{xy}*/Makefile") do |s|
      s.change_make_var! "LINKFORSHARED",
                         "#{opt_prefix}/Frameworks/Python.framework/Versions/#{xy}/Python"
    end

    %w[setuptools pip wheel].each do |r|
      (libexec/r).install resource(r)
    end

    if build.with? "sphinx-doc"
      cd "Doc" do
        system "make", "html"
        doc.install Dir["build/html/*"]
      end
    end
  end

  def post_install
    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{xy}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel].each do |pkg|
      (libexec/pkg).cd do
        system bin/"python3", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose", "--install-scripts=#{bin}",
               "--install-lib=#{site_packages}",
               "--single-version-externally-managed",
               "--record=installed.txt"
      end
    end

    rm_rf [bin/"pip", bin/"easy_install"]
    mv bin/"wheel", bin/"wheel3"

    # post_install happens after link
    %W[pip3 pip#{xy} easy_install-#{xy} wheel3].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl"].opt_lib]

    if build.with? "sqlite"
      include_dirs << Formula["sqlite"].opt_include
      library_dirs << Formula["sqlite"].opt_lib
    end

    if build.with? "tcl-tk"
      include_dirs << Formula["homebrew/dupes/tcl-tk"].opt_include
      library_dirs << Formula["homebrew/dupes/tcl-tk"].opt_lib
    end

    cfg = lib_cellar/"distutils/distutils.cfg"
    cfg.atomic_write <<-EOF.undent
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOF
  end

  def xy
    version.to_s.slice(/(3\.\d)/) || "3.6"
  end

  def sitecustomize
    <<-EOF.undent
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://github.com/Homebrew/brew/blob/master/docs/Homebrew-and-Python.md>
      import re
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{xy}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{xy}/lib/python#{xy}/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]

          # Set the sys.executable to use the opt_prefix
          sys.executable = '#{opt_bin}/python#{xy}'
    EOF
  end

  def caveats
    text = <<-EOS.undent
      Pip, setuptools, and wheel have been installed. To update them
        pip3 install --upgrade pip setuptools wheel

      You can install Python packages with
        pip3 install <package>

      They will install into the site-package directory
        #{site_packages}

      See: https://github.com/Homebrew/brew/blob/master/docs/Homebrew-and-Python.md
    EOS

    # Tk warning only for 10.6
    tk_caveats = <<-EOS.undent

      Apple's Tcl/Tk is not recommended for use with Python on macOS 10.6.
      For more information see: https://www.python.org/download/mac/tcltk/
    EOS

    text += tk_caveats unless MacOS.version >= :lion
    text
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python#{xy}", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python#{xy}", "-c", "import tkinter; root = tkinter.Tk()"
    system bin/"pip3", "list"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 2779658..902d0eb 100644
--- a/setup.py
+++ b/setup.py
@@ -1699,9 +1699,6 @@ class PyBuildExt(build_ext):
         # Rather than complicate the code below, detecting and building
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
-        if (host_platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
@@ -1747,22 +1744,6 @@ class PyBuildExt(build_ext):
             if dir not in include_dirs:
                 include_dirs.append(dir)

-        # Check for various platform-specific directories
-        if host_platform == 'sunos5':
-            include_dirs.append('/usr/openwin/include')
-            added_lib_dirs.append('/usr/openwin/lib')
-        elif os.path.exists('/usr/X11R6/include'):
-            include_dirs.append('/usr/X11R6/include')
-            added_lib_dirs.append('/usr/X11R6/lib64')
-            added_lib_dirs.append('/usr/X11R6/lib')
-        elif os.path.exists('/usr/X11R5/include'):
-            include_dirs.append('/usr/X11R5/include')
-            added_lib_dirs.append('/usr/X11R5/lib')
-        else:
-            # Assume default location for X11
-            include_dirs.append('/usr/X11/include')
-            added_lib_dirs.append('/usr/X11/lib')
-
         # If Cygwin, then verify that X is installed before proceeding
         if host_platform == 'cygwin':
             x11_inc = find_file('X11/Xlib.h', [], include_dirs)
@@ -1786,10 +1767,6 @@ class PyBuildExt(build_ext):
         if host_platform in ['aix3', 'aix4']:
             libs.append('ld')

-        # Finally, link with the X11 libraries (not appropriate on cygwin)
-        if host_platform != "cygwin":
-            libs.append('X11')
-
         ext = Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                         define_macros=[('WITH_APPINIT', 1)] + defs,
                         include_dirs = include_dirs,
