class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.17.1.tar.bz2"
  sha256 "711eabf5dd661b9b04be9edc9ace2a7bc031f6bd9d37a768d02d0efdef108f5f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ae8d80734f26c576a6bba331cc2d297fd8381529cc5837caadbb0848514fa54"
    sha256 cellar: :any,                 arm64_big_sur:  "35f92cc8f4d09dbfdbe2b2e98ae86a6810106d5f060e6a57b5bedc1c0ab32ffd"
    sha256 cellar: :any,                 monterey:       "d984b2487bd72c40a04edfb26b884a873eeca7ad1cecdacc60b41d774991ce55"
    sha256 cellar: :any,                 big_sur:        "306af04ce2798e3227e643806824fade33961b45a327a36ea5aaf56d27d6b9ec"
    sha256 cellar: :any,                 catalina:       "a529ae88cf38d8c578e81b90c871dfdfcaf2675ffb5aa173f2e62dd0bc005cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faec7ead15b656c2655f7a43cec3a5bc6bf9886763349b2fc03e5b85dd8b2abc"
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = which("python3")
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when distutils is no longer used. Related PR: https://dev.gnupg.org/D545
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
