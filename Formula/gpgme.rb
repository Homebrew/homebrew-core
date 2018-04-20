class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.11.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.11.1.tar.bz2"
  sha256 "2d1b111774d2e3dd26dcd7c251819ce4ef774ec5e566251eb9308fa7542fbd6f"

  bottle do
    cellar :any
    sha256 "c1861b16662ef573f7b03eb805a72ec6273190e145bf4bf7a8d1ad00d073af63" => :high_sierra
    sha256 "06ed9f78cf26c74a86bcc893a253d44d196095c97bac8e242cbd2f10dca7966c" => :sierra
    sha256 "fc47b92bce0b95574c97f0edfe3c8852507189cf734cd15f35c9d1ec1f0fca84" => :el_capitan
  end

  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libgpg-error"
  depends_on "libassuan"

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
