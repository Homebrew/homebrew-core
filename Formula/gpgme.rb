class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.10.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.10.0.tar.bz2"
  sha256 "1a8fed1197c3b99c35f403066bb344a26224d292afc048cfdfc4ccd5690a0693"

  bottle do
    cellar :any
    sha256 "f38978f086b4ad16d4bab4fd0363bd504ab3e8c192b38db4c6c7f61e6dc2c189" => :high_sierra
    sha256 "4658241075bdcabda50ba1092270a465c6f17add7c22e394988080db3d162cf1" => :sierra
    sha256 "760d8e2277b699e4e4a04c2753ea6bc0e45e0a2617c67f02318de69a8a2d060f" => :el_capitan
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
    system "python", "-c", "import gpg; print gpg.version.versionstr"
  end
end
