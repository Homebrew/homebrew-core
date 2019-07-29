class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.6.0.tar.gz"
  # checksum change reported upstream at https://github.com/profanity-im/profanity/issues/1094
  sha256 "f1b2773b79eb294297686f3913e9489c20effae5e3a335c8956db18f6ee2f660"
  revision 2

  bottle do
    sha256 "57d4299cc773dedb5a01221b414e97be579f025f50d8355bc965ae1750f9726b" => :mojave
    sha256 "407aeeb2f9f3faf5633814b3900f5f4d79888f6ad1a94e0b75be894bc061e0a1" => :high_sierra
    sha256 "7c3d5013c2b0c3ae7d4e1c56bc7a9552815feef3f19adaef0ec8de67d036b3b0" => :sierra
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
