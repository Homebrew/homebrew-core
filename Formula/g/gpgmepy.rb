class Gpgmepy < Formula
  desc "Python bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgmepy/gpgmepy-2.0.0.tar.bz2"
  sha256 "07e1265648ff51da238c9af7a18b3f1dc7b0c66b4f21a72f27c74b396cd3336d"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepy/"
    regex(/href=.*gpgmepy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2ff17284d52de5b8b7ef1c0f09c69cf1432ff8e87b78b405af9e8494aef5e147"
    sha256 cellar: :any, arm64_tahoe:       "6a62d45faaebb843bdbf0d0590e807cf16e4a29b2b8043488aab060a4b95d044"
    sha256 cellar: :any, arm64_sequoia:     "2417e9baa9e54f67032b1b1c418961b3e53ecb2a08d7d7c4d98e788a10cbff97"
    sha256 cellar: :any, arm64_linux:       "4c49be7b78d49b12275ae9b5c848d5466bb3d347e7dde717aace10813d5d0c34"
    sha256 cellar: :any, x86_64_linux:      "9a583f4914ffc342e51d6e57d80e976366853a49444730f6ab148e9ad71a431e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
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
