class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.12.1.tar.gz"
  sha256 "e344481e7bf3b16baf58a169d321b809c4700becffb70db6f1c39adc3fad306e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "de57a1808ee6ef8e5c37753ab3084c8bcf1aeb09019a0dc7481621b383f7ed2a"
    sha256 arm64_big_sur:  "d82a74a90bbd5bce3f7f63b55b63642e09b16f2fc734cca897d451492a4dec66"
    sha256 monterey:       "3a9ffd5cf97aadb416f734b2cac41db1008807e4de2aecfc1b3f100f3bc32cdb"
    sha256 big_sur:        "9969ff03174f4892225068a9d192d9912cfc7aaad4375414897079753e6a68e3"
    sha256 catalina:       "78e78180248d85a46c0f174cf539d4651c7c1870ad660e083509a0a7ce6dff99"
    sha256 x86_64_linux:   "f461e16ad0f01cd68b1c020408d381c0f6893f8ff60c8f7ae09c7377447d513e"
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

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "BREW=#{HOMEBREW_BREW_FILE}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
