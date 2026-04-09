class Gpgmepy < Formula
  desc "Python bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgmepy/gpgmepy-2.0.0.tar.bz2"
  sha256 "07e1265648ff51da238c9af7a18b3f1dc7b0c66b4f21a72f27c74b396cd3336d"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepy/"
    regex(/href=.*gpgmepy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f21cfcd0bfbe06c868c45a70af197e336567098acbdf5cfe3c63197565eaab2f"
    sha256 cellar: :any,                 arm64_sequoia: "e039368da6c31b0a4ce537e16e2183386025d513698a5f38b5ed88f6756feefd"
    sha256 cellar: :any,                 arm64_sonoma:  "6deed958494152e14d81aaa09da8a0988619712d47aea78a12acb3f4b765fbb7"
    sha256 cellar: :any,                 sonoma:        "7953997037c8aaa348df99bd4d38f8338f78ffb5bb884dd5b401cff56a59583e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15297aab49987be773de7612b691c49f214ab2b0db01a123e8aa15d06f97872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df957ddc15a4b7d2c3b26868e8371b60363b2417e4b990eef4dcfd80b572f88"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def python3
    "python3.14"
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
