class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.2.tar.bz2"
  sha256 "e11b1a0e361777e9e55f48a03d89096e2abf08c63d84b7017cfe1dce06639581"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f050cd4be93a9a506d374f44be63b13f0063bea568c7508c947be36cd4fcf510"
    sha256 cellar: :any,                 arm64_sonoma:  "243da3ea18b40219a0e492c3134b227964de1d7f2509e0f4c1cb9f0732865293"
    sha256 cellar: :any,                 arm64_ventura: "62377cb3e11c7a85073332bb74b41b95fefe78cb19e5b93d4f42d9907474da28"
    sha256 cellar: :any,                 sonoma:        "a04dc7c0d5059dbf98dee9468fb4ea7f417c00b81fa1a4ae4050f95f60f9e7c9"
    sha256 cellar: :any,                 ventura:       "37e0d6e8cb0e550287cb803d3ec681714946620e25fb33db1fb0d1d90c3307f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c9d0a35852fb8e4150565e90082733032e5827cc0d1ac2fa35b725553c47fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baea5b8942625d34400cec21d2c90952b265847fd0bc01cb5294eea63eb6993b"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.13"
  end

  def install
    ENV["PYTHON"] = python3
    # HACK: Stop build from ignoring our PYTHON input. As python versions are
    # hardcoded, the Arch Linux patch that changed 3.9 to 3.10 can't detect 3.11
    inreplace "configure", /# Reset everything.*\n\s*unset PYTHON$/, ""

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    # Use pip over executing setup.py, which installs a deprecated egg distribution
    # https://dev.gnupg.org/T6784
    inreplace "lang/python/Makefile.in",
              /^\s*\$\$PYTHON setup\.py\s*\\/,
              "$$PYTHON -m pip install --use-pep517 #{std_pip_args.join(" ")} . && : \\"

    system "./configure", "--disable-silent-rules",
                          "--enable-static",
                          *std_configure_args
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix

    # replace libassuan Cellar paths to avoid breakage on libassuan version/revision bumps
    dep_cellar_path_files = [bin/"gpgme-config", lib/"cmake/Gpgmepp/GpgmeppConfig.cmake"]
    inreplace dep_cellar_path_files, Formula["libassuan"].prefix.realpath, Formula["libassuan"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
