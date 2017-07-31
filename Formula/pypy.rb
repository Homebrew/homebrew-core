class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  head "https://bitbucket.org/pypy/pypy", :using => :hg

  stable do
    url "https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.8.0-src.tar.bz2"
    sha256 "504c2d522595baf8775ae1045a217a2b120732537861d31b889d47c340b58bd5"
  end

  bottle do
    cellar :any
    sha256 "c48d311687f16f915fd56ce9e88b5d0f451b89a1eafdaa0d4c8520169ed8f7c4" => :sierra
    sha256 "2877949d25955bb4224c1b325ff395976a1526f515a4e6ae7a8b43bb846bf28c" => :el_capitan
    sha256 "3ed8667a61007b433e7d4fc854604b8e9439615c3eacf633958b1bad27cbb395" => :yosemite
  end

  option "without-bootstrap", "Translate Pypy with system Python instead of " \
                              "downloading a Pypy binary distribution to " \
                              "perform the translation (adds 30-60 minutes " \
                              "to build)"

  depends_on :arch => :x86_64
  depends_on "pkg-config" => :build
  depends_on "gdbm" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "openssl"

  resource "bootstrap" do
    url "https://bitbucket.org/pypy/pypy/downloads/pypy-2.5.0-osx64.tar.bz2"
    sha256 "30b392b969b54cde281b07f5c10865a7f2e11a229c46b8af384ca1d3fe8d4e6e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/25/4e/1b16cfe90856235a13872a6641278c862e4143887d11a12ac4905081197f/setuptools-28.8.0.tar.gz"
    sha256 "432a1ad4044338c34c2d09b0ff75d509b9849df8cf329f4c1c7706d9c2ba3c61"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz"
    sha256 "09f243e1a7b461f654c26a725fa373211bb7ff17a9300058b205c61658ca940d"
  end

  # https://bugs.launchpad.net/ubuntu/+source/gcc-4.2/+bug/187391
  fails_with :gcc

  def install
    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    python = "python"
    if build.with?("bootstrap") && MacOS.prefer_64_bit?
      resource("bootstrap").stage buildpath/"bootstrap"
      python = buildpath/"bootstrap/bin/pypy"
    end

    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy --targetdir . --nostrip]
      package_args << "--without-gdbm" if build.without? "gdbm"
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "pypy.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/libpypy-c.dylib"
    MachO::Tools.change_install_name("#{libexec}/bin/pypy",
                                     "@rpath/libpypy-c.dylib",
                                     "#{libexec}/lib/libpypy-c.dylib")

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"lib/libpypy-c.dylib"
  end

  def post_install
    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    unless (libexec/"site-packages").symlink?
      # fix the case where libexec/site-packages/site-packages was installed
      rm_rf libexec/"site-packages/site-packages"
      mv Dir[libexec/"site-packages/*"], prefix_site_packages
      rm_rf libexec/"site-packages"
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils+"distutils.cfg").atomic_write <<-EOF.undent
      [install]
      install-scripts=#{scripts_folder}
    EOF

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<-EOS.undent
    A "distutils.cfg" has been written to:
      #{distutils}
    specifying the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install_pypy,
    or pip_pypy, any provided scripts will go into the install-scripts folder
    above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
    so you don't overwrite tools from CPython.

    Setuptools and pip have been installed, so you can use easy_install_pypy and
    pip_pypy.
    To update setuptools and pip between pypy releases, run:
        pip_pypy install --upgrade pip setuptools

    See: https://docs.brew.sh/Homebrew-and-Python.html
    EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/2.7/distutils"
  end

  test do
    system bin/"pypy", "-c", "print('Hello, world!')"
    system bin/"pypy", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end
