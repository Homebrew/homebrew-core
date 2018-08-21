class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.11.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.11.1.tar.bz2"
  sha256 "2d1b111774d2e3dd26dcd7c251819ce4ef774ec5e566251eb9308fa7542fbd6f"

  bottle do
    cellar :any
    sha256 "a91bc4690b429612ec4c855d0f7875f2857ab7dcb6638453c23f390fae9c9e31" => :mojave
    sha256 "8a4e1bbd9ce26be05a9f0875c7f258c36fc3387d6cf628684c6f5427a63402ca" => :high_sierra
    sha256 "90e45544ee3e670f1f8e808b504057d360a260c33cf34682e3a3686b6a4cda83" => :sierra
    sha256 "88f9c39143597eadd5a408bc8e5b1580014358977d8f3a7cb89c0ac6372510db" => :el_capitan
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
