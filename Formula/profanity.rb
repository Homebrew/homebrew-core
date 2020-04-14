class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.8.1.tar.gz"
  sha256 "6b7ff1f0f1b54ed3a55efce40237db775fe9475af276e5e4ed342e91a3e8d997"
  revision 1

  bottle do
    sha256 "301cf17605c91fc2c1d61a6ca5c08bca3b91676133f6cb208be0cd4539a4657b" => :catalina
    sha256 "ba2cc6e92cd20f4b324d81c5762445f633a7318f50fe87a0cd0373a1427b00b7" => :mojave
    sha256 "61aac65b0490da4ef367909d7427b83b98fdbfb7ebacda571d8772c624d5fc7b" => :high_sierra
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
