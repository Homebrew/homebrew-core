class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.7.1.tar.gz"
  sha256 "3fe442948ff2ee258681c3812e878d39179dcf92e1c67bc8fe0ef8896440b05b"

  bottle do
    sha256 "49f5899461484c5ac2f7417ea4392b5cdc9a6d8811900261533b22284e405e54" => :catalina
    sha256 "f22a03bebff8b2f665f43d53fb73f85d43c4527335df6a51e7600dbb0fb5828e" => :mojave
    sha256 "98a55ec40c11d1909d4651cf3263e20da2a698acee294a2ea1241cec140aae6b" => :high_sierra
    sha256 "f5ec5037194ddf9117317fed8f521129904b1d13cd24a3133267f13fb9c914eb" => :sierra
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
