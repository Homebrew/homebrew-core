class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "https://profanity-im.github.io/profanity-0.7.0.tar.gz"
  sha256 "f1eb99be01683d41b891b0f997f4c873c9bb87b0b6b8400b7fccb8e553d514bb"
  revision 1

  bottle do
    sha256 "aa0bb43ad03a8592b35f5ac3fb1caadfcd31c72943e86415be89880e97910368" => :mojave
    sha256 "363d62a285f34d667a51ae92421228ba6f9b1631476671d6d67e5dffd3ea9422" => :high_sierra
    sha256 "7104989e5353adf38de55c57b57de8b6afbd7a369cd4df335eae385f3eb4d184" => :sierra
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
  depends_on "openssl@1.1"
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
