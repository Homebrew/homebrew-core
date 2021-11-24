class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.11.1.tar.gz"
  sha256 "6f1b4df6c2971f51d03d48d2bfd4f69b4404410d800b43f029ea1cf08a02bd45"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "f2f1940db34f5f4dbd8e98417e591ae1a3afcaa5270a7993c09a2278cc5dbd88"
    sha256 arm64_big_sur:  "f25f8e773bc05b798776a12b213bcf96edd7eb59d5b30e933ac1231e6a89fe7f"
    sha256 monterey:       "87106dc7e112e37b7307f6a3ff7ca4565c0e269a37c0486b5778648614907e19"
    sha256 big_sur:        "01f299b832782d3ed87ad78fc432c1a20799b3804140c017671ddde7c5b4fb42"
    sha256 catalina:       "1096a2f8ed2d6bedc3dd67f6247dee1a35ceb17c6af052161c026865fb318c4d"
    sha256 mojave:         "3187f12ce661fbf90021b11e313d9a98b5b65da311d04807283f0722539e4f7b"
    sha256 x86_64_linux:   "1e0abc2724db615d5997766a64fd0b22be03b25fc1e47c4fd07dd509633024ee"
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

    # `configure` hardcodes `/usr/local/opt/readline`, which isn't portable.
    # https://github.com/profanity-im/profanity/issues/1612
    # Remove in version 0.12.0.
    inreplace "configure", "/usr/local/opt/readline", Formula["readline"].opt_prefix

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
