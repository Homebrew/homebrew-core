class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.7.1.tar.gz"
  sha256 "3fe442948ff2ee258681c3812e878d39179dcf92e1c67bc8fe0ef8896440b05b"

  bottle do
    sha256 "e758626095ed29ecb2165ed66fbd94ff33208bc021734c9b6da8ad07cc8ba9ef" => :catalina
    sha256 "635da190c3390f3afbb8cd950cf325904b18a139ed3326950b101f1ba29c0cee" => :mojave
    sha256 "00c708f8f2061059b919b9033775730ea0587671d5e1d0a45214de3599f676ed" => :high_sierra
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
