class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.12.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.12.0.tar.bz2"
  sha256 "b4dc951c3743a60e2e120a77892e9e864fb936b2e58e7c77e8581f4d050e8cd8"

  bottle do
    cellar :any
    sha256 "7a606e568e5708cb6461f4988c1ccaab2eb58be8e6d4b96efbe0d5bbc64b612c" => :mojave
    sha256 "2d69d89cb6cb2eca32dd6fc92e32251d12c946c93917d5d6e6c4cebc421d23c7" => :high_sierra
    sha256 "bb4ac5c5bbc9f3f2c54febe2e872c780337d6c8612124778b76826371c673492" => :sierra
  end

  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
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
    system "python2.7", "-c", "import gpg; print gpg.version.versionstr"
  end
end
