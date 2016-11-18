class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.0.tar.gz"
  sha256 "783be8aa6eab7192fc211f00adac136b21e580ea52d9c07128312a9609939668"

  bottle do
    sha256 "16c6bad33b79547d3704eac09cc47cd419108ee229f45b05b485a1cc7013d768" => :sierra
    sha256 "d2bd1f9941cb5ae5227b9c4bb253fa647788c5e3f46c90f384173ff5b4f43d96" => :el_capitan
    sha256 "0766255c85298c03ceffb45192fb0945240e1ba186aea4b8b014208e8611f1c2" => :yosemite
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
                          "--disable-python-plugins",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
