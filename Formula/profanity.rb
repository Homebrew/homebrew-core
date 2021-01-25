class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.10.0.tar.gz"
  sha256 "4a05e32590f9ec38430e33735bd02cfa199b257922b4116613f23912ca39ff8c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 "c997a1e4dd8e64b5cef0a457b734831f84741b45d8d630aa81a89f231499bd42" => :big_sur
    sha256 "aea5848ba083a0cabee58d7c8bf09220c193287d144321374207cd913d88d397" => :catalina
    sha256 "c146f06dbe713c3e762e0c4ec9ca3c056b6fdb71d641e8905ce9a76ef90ce1eb" => :mojave
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
