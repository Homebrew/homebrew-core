class Gpgmepy < Formula
  desc "Python bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgmepy/gpgmepy-2.0.0.tar.bz2"
  sha256 "07e1265648ff51da238c9af7a18b3f1dc7b0c66b4f21a72f27c74b396cd3336d"
  license "LGPL-2.1-or-later"
  revision 3

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepy/"
    regex(/href=.*gpgmepy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67765915340994b0acd669d108070ee753de90d69e4bf054c1fb7da7239e5cb4"
    sha256 cellar: :any, arm64_tahoe:       "9e1fa1d94dd0bcfc4897addca66ccb19c1fbf092faf80bce665d8fb88096871e"
    sha256 cellar: :any, arm64_sequoia:     "d5c8644e326aa49b16499caf5f482eac879c6e285fc6318edd224502590ae647"
    sha256 cellar: :any, arm64_linux:       "f2cdb0cad08229896c14a35f830e392278c966d5fd69c01d03bfe77b986b2671"
    sha256 cellar: :any, x86_64_linux:      "2669d1fee16edac9e9bcfb1c00ca141e329984bc515a22a95f2a8d51e21990ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  # Fix build with SWIG 4.5, which dropped the Python 2 compat macros the typemaps still use
  patch do
    url "https://sources.debian.org/data/main/g/gpgmepy/2.0.0-3/debian/patches/0030-build-with-swig-4.5.0.patch"
    sha256 "71e1a543ee8d22b2a62d5dd7b5d7095c53f20271b17f06dd413e7c6b9bb34772"
    type :unofficial
    resolves "https://bugs.debian.org/1145351"
  end

  def install
    # Use pip over executing setup.py, which installs a deprecated egg distribution
    # https://dev.gnupg.org/T6784
    inreplace "Makefile.in",
              /^\s*\$\$PYTHON setup\.py\s*\\/,
              "$$PYTHON -m pip install #{std_pip_args.join(" ")} . && : \\"

    system "./configure", *std_configure_args
    system "make", "COPY_FILES="
    system "make", "install"
  end

  test do
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
