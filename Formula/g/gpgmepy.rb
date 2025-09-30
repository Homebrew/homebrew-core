class Gpgmepy < Formula
  desc "Python bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgmepy/gpgmepy-2.0.0.tar.bz2"
  sha256 "07e1265648ff51da238c9af7a18b3f1dc7b0c66b4f21a72f27c74b396cd3336d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepy/"
    regex(/href=.*gpgmepy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "227cd3223104de67e57a5f7500d6ab61e065c643909ecbdc3b4c9cd5c9bde491"
    sha256 cellar: :any,                 arm64_sequoia: "76e4c10156cd7a5024c68a73457af753117a791207bf8fab1ab9c7efed9abf97"
    sha256 cellar: :any,                 arm64_sonoma:  "9a095dc289423a169dc55a625e4329c62650d82d1583dc95f404426c8376bfc3"
    sha256 cellar: :any,                 arm64_ventura: "dec7ec82d9bbf770542f46bf855fc9155d4ad797aa022961f6857a68fadb6031"
    sha256 cellar: :any,                 sonoma:        "dea7848684bcc3a485e1057b8ffdc85e1fe8bf4c368fd412af463400df9fbcc9"
    sha256 cellar: :any,                 ventura:       "09c7f84105d74eba8559a18c5e07199e66aba5f079d88337f3632061feff53aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d773b5a78acc31cc6da039aa5d03521690a00814ba30e60d5ed09ff4306d9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dbeaa8b3946bfcee60844911d374750225c264fc63f699289e7f28e91bf7c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def python3
    "python3.13"
  end

  def install
    # Use pip over executing setup.py, which installs a deprecated egg distribution
    # https://dev.gnupg.org/T6784
    inreplace "Makefile.in",
              /^\s*\$\$PYTHON setup\.py\s*\\/,
              "$$PYTHON -m pip install --use-pep517 #{std_pip_args.join(" ")} . && : \\"

    system "./configure", *std_configure_args
    system "make", "COPY_FILES="
    system "make", "install"
  end

  test do
    system python3, "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
