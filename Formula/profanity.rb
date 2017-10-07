class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.1.tar.gz"
  sha256 "e3513713e74ec3363fbdbac2919bdc17e249988780cc5a4589d1425807a7feb8"

  bottle do
    rebuild 1
    sha256 "927877fecb1306de71150281968d62ebc20d3e2fb70a43706d759d31f9b46d3d" => :high_sierra
    sha256 "e1944f29f1fb1233f43c9beac4e4f6c4af247e64e94fa9c1c3b77fc4071124aa" => :sierra
    sha256 "759ebf658a3a869b22da48f7c6a99dbad605c75af19931cef996ef3484df5d29" => :el_capitan
  end

  head do
    url "https://github.com/boothj5/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"
  depends_on "libstrophe"
  depends_on "readline"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "gpgme" => :recommended
  depends_on "terminal-notifier" => :optional

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
