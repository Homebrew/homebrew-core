class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.9.4.tar.gz"
  sha256 "661ce37ad28f5e4e204e28719403daba5330612f607c3d636050d69ad1d5901a"

  bottle do
    sha256 "c447b714d3f1dff8a32cbc6d7d3ffea2738bb37cd2c7b296d9f7caf97acd18d1" => :catalina
    sha256 "d646b336478d46603d326e52a0b6d14e585d4df0069e5e3bee93aec863c0cc7c" => :mojave
    sha256 "50327e2a08246b4f70aa61831bc805d27edbd2a092ca8507cafa647fe351612c" => :high_sierra
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
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "terminal-notifier"

  uses_from_macos "curl"

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
