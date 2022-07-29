class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.12.1.tar.gz"
  sha256 "e344481e7bf3b16baf58a169d321b809c4700becffb70db6f1c39adc3fad306e"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "4491270163d04d1d5874bf2b5e53867e68ba8dc1f9a3748b8a7b3e05c53d0446"
    sha256 arm64_big_sur:  "5cec786d1d6f83c9f8891d9f43757c102b4d772b5f17f307b34b025bfdfcfdd4"
    sha256 monterey:       "1f89863e738b50d2427fa6c5b26d2863415f61b9d1931513b91d26070986935c"
    sha256 big_sur:        "1c0f9f141b56574353271d0f2cdbdd4651f15f7a118814cad0e385e6cb2acfe4"
    sha256 catalina:       "7ffd16eed0fbded7d26779049fbfa5a509e1b7a265f6bb5ba93dad3e7c79dc3c"
    sha256 x86_64_linux:   "7b3f6fd3f611ab122e580e497cd008278bf849706ba8191f28ccb296d6ca43e2"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "readline"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    system "./bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "BREW=#{HOMEBREW_BREW_FILE}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
