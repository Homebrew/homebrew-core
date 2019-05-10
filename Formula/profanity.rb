class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.6.0.tar.gz"
  # checksum change reported upstream at https://github.com/profanity-im/profanity/issues/1094
  sha256 "f1b2773b79eb294297686f3913e9489c20effae5e3a335c8956db18f6ee2f660"
  revision 1

  bottle do
    sha256 "6c5d08457285bf82bf9a0b40dd98d0fbf69b558c7e53d53cfb4a23df7f698fe5" => :mojave
    sha256 "ecea4e8185066366a4474c0d2e001bc308ffcd11f2e6c03d3620c1eea1e214e3" => :high_sierra
    sha256 "cfddb383475bd23916318bbb433133a7e5c8d7ad84a19d002013e88bcdce0af2" => :sierra
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
