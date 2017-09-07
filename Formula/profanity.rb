class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.1.tar.gz"
  sha256 "e3513713e74ec3363fbdbac2919bdc17e249988780cc5a4589d1425807a7feb8"

  bottle do
    sha256 "56c5f3d0cc13161ff432299e568d53568dd31d001b69a926fa8e20a534950a46" => :high_sierra
    sha256 "6c25fa2f09c53b761f1d5ec9e30ff729fada4b1496e4852ae54b42ec8abee62c" => :sierra
    sha256 "7b71f78407ab50478f50ed07a5f5e559ba177530d4358626681abcb28552529f" => :el_capitan
    sha256 "539594946baa70bf330cd995fa65217aa6d3b02c0523227fd833be704c010b37" => :yosemite
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
