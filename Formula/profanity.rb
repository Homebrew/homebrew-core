class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.1.tar.gz"
  sha256 "e3513713e74ec3363fbdbac2919bdc17e249988780cc5a4589d1425807a7feb8"
  revision 2

  bottle do
    sha256 "dd2ab5d3289b608ad571a52fa3fc97b8f5d667d26b77401990dee17c79d59e0e" => :mojave
    sha256 "897164098c73e5b7bebcdf270f8d186be2d3212bffbcb9a725f0a1489a9f3185" => :high_sierra
    sha256 "69bad8ec90911ce11a618612b9b63c903f240e0ff1627c536e99849609094f8f" => :sierra
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
