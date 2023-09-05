class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.22.0.tar.bz2"
  sha256 "9551e37081ad3bde81018a0d24f245c3f8206990549598fb31a97a68380a7b71"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fc529dd5239bbf289d13f0f01c8e3b62c09ecf28b721d36573e5ec85dbdebd11"
    sha256 cellar: :any,                 arm64_monterey: "28dd91b3a53218195b80764766578a2248f9bda4f867347c92771f404c68421c"
    sha256 cellar: :any,                 arm64_big_sur:  "56c71d9cf05e3fc7cf24eb7578d8795e4535be402c24197019155454f92c2022"
    sha256 cellar: :any,                 ventura:        "278162f8fd37221612f935e297170a144a61f8b1bb9fe6529c0344f738c1bcc9"
    sha256 cellar: :any,                 monterey:       "413658de4b53231ea36461d0acd434a1af3e18fbe01c15e0c03b5afc418eccca"
    sha256 cellar: :any,                 big_sur:        "27ee36120bf7846c41982e613236765e23b1af0d05dc9e9813d46b5f3da2336f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0bceef522dc84b3f29d1814e151a30b96d82438e093b1ad03f9372779e1196"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def python3
    "python3.11"
  end

  def install
    ENV["PYTHON"] = python3
    # HACK: Stop build from ignoring our PYTHON input. As python versions are
    # hardcoded, the Arch Linux patch that changed 3.9 to 3.10 can't detect 3.11
    inreplace "configure", /# Reset everything.*\n\s*unset PYTHON$/, ""

    # Uses generic lambdas.
    # error: 'auto' not allowed in lambda parameter
    ENV.append "CXXFLAGS", "-std=c++14"

    site_packages = prefix/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages
    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "lang/python/Makefile.in",
              /^\s*install\s*\\\n\s*--prefix "\$\(DESTDIR\)\$\(prefix\)"/,
              "\\0 --install-lib=#{site_packages}"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static"
    system "make"
    system "make", "install"

    # Rename the `easy-install.pth` file to avoid `brew link` conflicts.
    site_packages.install site_packages/"easy-install.pth" => "homebrew-gpgme-#{version}.pth"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
