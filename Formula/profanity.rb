class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "https://profanity-im.github.io/profanity-0.7.0.tar.gz"
  sha256 "f1eb99be01683d41b891b0f997f4c873c9bb87b0b6b8400b7fccb8e553d514bb"

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
