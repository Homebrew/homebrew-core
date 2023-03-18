class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.19.0.tar.bz2"
  sha256 "cb58494dc415fba9eeb12b826550ad3190dc92e265c5bb2ae1a21c92841cfd38"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9decafe66ad24f1a8bb93df58020043ad069042f32180ef464e4dda97d486f33"
    sha256 cellar: :any,                 arm64_monterey: "fe38d5bd1dd1fe42fada2b9b1530e84ef50563d9698d35417f86e29e976cccb1"
    sha256 cellar: :any,                 arm64_big_sur:  "2b9e01bcea5576c72532d1356f6fffeb37d125b9493f75ad6c319765ff4aa6d0"
    sha256 cellar: :any,                 ventura:        "10ef09d6f4fc711dedc115d77dfc2cd00bb23aef67a1cdd4d600a6d8a5190921"
    sha256 cellar: :any,                 monterey:       "3cdfe6c74bd7be4a3d006b868f44f0e35a28308fe5082abd516a4fd07a5fae5a"
    sha256 cellar: :any,                 big_sur:        "22eff205c6e8eed22a91c94e051756f4635146c0ed66b8bd11b559a36442f5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21424619b3068e7a30f8ae086cd033e0421627d280c89d05ddeaf960d4f1c293"
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
