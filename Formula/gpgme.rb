class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.9.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.9.0.tar.bz2"
  sha256 "1b29fedb8bfad775e70eafac5b0590621683b2d9869db994568e6401f4034ceb"
  revision 1

  bottle do
    cellar :any
    sha256 "08257999c039fa4da77f534c181d66e0a6414a25e5d5e30053efc27927ebfecd" => :sierra
    sha256 "0594b2bf6fc1fe12a78b514b91d63595893db4f6fb8f6f287eb4e457d5795a94" => :el_capitan
    sha256 "7e42daede60b5548ccdf5b42a077b824c5365b8c2d704bb6c892d30acefa6f43" => :yosemite
  end

  depends_on "gnupg"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

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
  end
end
