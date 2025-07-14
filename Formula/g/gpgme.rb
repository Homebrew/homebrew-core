class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.3.tar.bz2"
  sha256 "bfc17f5bd1b178c8649fdd918956d277080f33df006a2dc40acdecdce68c50dd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "2c66995cde33a82fe56ec3a9310e8510cbf222da60b2a4602ee3fc64c6f93b8f"
    sha256                               arm64_sonoma:  "f7fbaccad97dba68beba223f6968fbd0ad5414a4cb67743eaf11ee1cb7ed394f"
    sha256                               arm64_ventura: "735a2f620ddc067d162045dbd56f0dda6f34494ee8fc2c6d79db5cb035fb9955"
    sha256 cellar: :any,                 sonoma:        "9d7d49aec57a889c8505ab5d4fd5a42604b244f671432e88dbb5eedbfa6cd2a0"
    sha256 cellar: :any,                 ventura:       "ce54ced3aba72951eafcb9cda15e1a5fb98a5fd4969f5f180bbabe9e312c1e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfb6e3fddc6cb22702693c3e5c63dea2adeac6da18ba8796459081d67691ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb901798817b1ffebf06359bcf72f1fd4cc31d8f008b8ff8ae79d015823058f9"
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
