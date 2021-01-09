class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.10.0.tar.gz"
  sha256 "4a05e32590f9ec38430e33735bd02cfa199b257922b4116613f23912ca39ff8c"
  license "GPL-3.0"

  bottle do
    sha256 "e674dc595aef44e934d0ae9ca90b46a42b2b10295b8dcd732f55475cb20c1acb" => :big_sur
    sha256 "b53f7fbd103d911f55337861bf36957cfaead39e8c38478ed03eceb41b507872" => :catalina
    sha256 "7112d51c1a187ca47b6d245d5600b46b3f0765efd5f2a215ce1a2d2327f2b884" => :mojave
    sha256 "21837ee57161928d0389dcd7170245b61e0d2f2c8b2f702dc6127bd98380b477" => :high_sierra
  end

  head do
    url "https://github.com/profanity-im/profanity.git"

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
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "curl"

  on_macos do
    depends_on "terminal-notifier"
  end

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
