class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.11.0.tar.gz"
  sha256 "3fc9809816f69186dbb860b27183f6cd2aef0a52a7d14e20e4ef6c3a7f0f3606"
  license "GPL-3.0-or-later"

  bottle do
    sha256 big_sur:      "969adf8ec31291af0845c5908d3aff338fd941dc3b938ece43a1962357f53622"
    sha256 catalina:     "76b3363d89c561b19cb9ac9a10fa1e81b433545400a2aa0f648b9541a1ffd7bb"
    sha256 mojave:       "cb5376e9ccd4f1b0f43d5c5f43cf9677f6b87f47a649224b7a2cb41da8a913e9"
    sha256 x86_64_linux: "8a08554c08409622eaf7c22a20922fce2cd90f54266f11fa59435da5cc7c30b9"
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
