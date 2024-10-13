class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.23.2.tar.bz2"
  sha256 "9499e8b1f33cccb6815527a1bc16049d35a6198a6c5fae0185f2bd561bce5224"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3be0ed36949874bc0c6b0b5936750b498cc6d74ff5949bef213c1bbc252ecc7c"
    sha256 cellar: :any,                 arm64_sonoma:   "5990f0751f5bce504beaaa9379e0bb082cea842010a6f94f11cfe0c99baba01b"
    sha256 cellar: :any,                 arm64_ventura:  "4cf824bf4138deda8878af6ad5ea2e6af519a8d7793c0a168f724799d5f97e42"
    sha256 cellar: :any,                 arm64_monterey: "5b94224d8226e2e49d3ea30bf5bd3d76672a5fd1fb59cdfbf160c35e6d2a4fa3"
    sha256 cellar: :any,                 sonoma:         "acb0a393ab4537dd314676d8dbbbf846fc14726cba00c32b027e18f11a603db3"
    sha256 cellar: :any,                 ventura:        "3ffd9fce9f2862c9a35562462356530c4bc46d23e1b23e58e36aede36348fb74"
    sha256 cellar: :any,                 monterey:       "05b1e5854b7a8eef9edb2a45208bfbdacd28bb243fabc60f350cabcd0b26080d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691a6fb7cf753251e8feafa30229cbba63a976820b2d33522ef413774788e6c0"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.12"
  end

  # Backport fix for newer setuptools
  patch do
    url "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgme.git;a=patch;h=ecd0c86d62351d267bdc9566286c532a394c711b"
    sha256 "69202c576f5f9980bc88bf9e963fd6199093c89ab8dc3be02ab6c460d65fe1b4"
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
