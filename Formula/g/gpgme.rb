class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.1.tar.bz2"
  sha256 "ea05d0258e71061d61716584ec34cef59330a91340571edc46b78374973ba85f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4817886d1fd2a4bfaa9b895ef0a57ae83b2728ed2ccf4430a6c46ea130764a14"
    sha256 cellar: :any,                 arm64_sonoma:  "647b8377a6821214e63e6367692acf707217c2f961cc682727dd855a5a1ae13e"
    sha256 cellar: :any,                 arm64_ventura: "25c16405a157103f48b918a8205c2bc6329a58de7ac1a40e6d47c63ab76e5763"
    sha256 cellar: :any,                 sonoma:        "ada24cc3c379aab878c538753ce1d112d2a5d7ac43a521755ade797eb984100d"
    sha256 cellar: :any,                 ventura:       "9654900d27991ce8b5f69d2ef5010237b2a47b5d12fd108ae9da8adc94654646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7484caa7a112dc0d76711a3861dcac6cd8c48d3125317b8330e03dbca15e0c0a"
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
