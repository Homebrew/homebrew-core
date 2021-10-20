class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.11.1.tar.gz"
  sha256 "6f1b4df6c2971f51d03d48d2bfd4f69b4404410d800b43f029ea1cf08a02bd45"
  license "GPL-3.0-or-later"

  bottle do
    sha256 big_sur:      "01f299b832782d3ed87ad78fc432c1a20799b3804140c017671ddde7c5b4fb42"
    sha256 catalina:     "1096a2f8ed2d6bedc3dd67f6247dee1a35ceb17c6af052161c026865fb318c4d"
    sha256 mojave:       "3187f12ce661fbf90021b11e313d9a98b5b65da311d04807283f0722539e4f7b"
    sha256 x86_64_linux: "1e0abc2724db615d5997766a64fd0b22be03b25fc1e47c4fd07dd509633024ee"
  end

  head do
    url "https://github.com/profanity-im/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "readline"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

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
