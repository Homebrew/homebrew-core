class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.1.tar.gz"
  sha256 "e3513713e74ec3363fbdbac2919bdc17e249988780cc5a4589d1425807a7feb8"
  revision 2

  bottle do
    sha256 "51cfcfe6bd1cbada4749999ae0dd26a9285b8f8c7e756dc7e38ca879394792b4" => :mojave
    sha256 "c97ecd459069c638acb346488507b3f216c485d5667f3999875b8166e2e36fef" => :high_sierra
    sha256 "50e1f4970c62dfd02c0c0fe5f439d87d18d6de276fdc2982c7713b74a57e38d9" => :sierra
    sha256 "90d81d6a2f308a5ae8a0ed69abcea2e4ed531f3d237600b51d41406c705f6443" => :el_capitan
  end

  head do
    url "https://github.com/boothj5/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "terminal-notifier"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
