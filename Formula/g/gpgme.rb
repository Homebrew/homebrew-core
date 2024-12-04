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
    sha256 cellar: :any,                 arm64_sequoia: "d527527678278ec8a1d1bbbfe47ae4c14ec6efde616ff423a444f620731cfa66"
    sha256 cellar: :any,                 arm64_sonoma:  "126aa60956ea71060c3a7214a208909f44c5ef3d809b8861a11be31dd88090b9"
    sha256 cellar: :any,                 arm64_ventura: "ad15a53119725ccc499fea4aa7611fcacd7b0e517913c3d4be5e07bd7a9bac13"
    sha256 cellar: :any,                 sonoma:        "1f5747663a4d8fa271388a8683ae2d87ab4e10247ef5189b575b980dce82438b"
    sha256 cellar: :any,                 ventura:       "ded898081e74189b242056b66b5979d86f11de849d4569ddd64c9a9f904e2ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5a08c5f2e458631a86a0a3447813157356513bfb0649307883fa53f84abac5"
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
