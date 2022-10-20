class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.13.1.tar.gz"
  sha256 "2b5075272e7ec9d9c991542e592b1d474fff88c61c66e7e23096ad306ed2c84a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "37c4545b4a013ca98264016894bc2c406c1539507eda7316de8d210a769125b7"
    sha256 arm64_big_sur:  "1947e2cfcf943db8ce339de7f52d8fe9d195bcd7d0757c225264afe058f99763"
    sha256 monterey:       "da577ee3160f2a7f6c21b32950b81ef77a11e8cafa4a0a92811ae0eac48d1936"
    sha256 big_sur:        "03ce9b98ccecab5dc51f0e2291a026fa4bd4886d64c136e708e96f408c731302"
    sha256 catalina:       "ea7d1750d7442902e5f62c2ee4b990169c8e5b38eeaa7dd7915239eba676d835"
    sha256 x86_64_linux:   "81a6bc85821548cfeb2e7e263044eaf6c8e35cb8b74a5715da6660e07c888666"
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
