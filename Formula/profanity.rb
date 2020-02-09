class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.8.1.tar.gz"
  sha256 "6b7ff1f0f1b54ed3a55efce40237db775fe9475af276e5e4ed342e91a3e8d997"

  bottle do
    sha256 "7e834ed11e71032a8691cd5ab0ff517e8ea365560b49bb9afc2121fb145bc698" => :catalina
    sha256 "d24fd144b29a16b5126d4a54f10881d3f7f24a7a939246ec31c8cdbee3677005" => :mojave
    sha256 "a5eaf989449eb778cdc2a17f4d00b8fbd0e58257d5f1ab5145b6a229a991d2b9" => :high_sierra
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
