class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.6.0.tar.gz"
  # checksum change reported upstream at https://github.com/profanity-im/profanity/issues/1094
  sha256 "f1b2773b79eb294297686f3913e9489c20effae5e3a335c8956db18f6ee2f660"
  revision 1

  bottle do
    sha256 "e5249cc2d5a6382f385ed3986485942db175c41a96c261cbbc88992fc18b11b1" => :mojave
    sha256 "bf44c79e3907a1fd4d6c2b40759a680b31163d4f63bbcb0d9ebb4a56a2702c7e" => :high_sierra
    sha256 "2b7c7f7fe0f7348191dabb78964dfbb4ec1b2cb4ede5a09c36449918930b1604" => :sierra
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
