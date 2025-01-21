class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "5472427158d470dc62004a3eff884d110f543dd5e3bb51e39942221fec17b2bd"
    sha256 arm64_sonoma:  "d32e8c7bdc2ee007a81b549fe0e653abc78bc72af6169657ae818a4b03d769bc"
    sha256 arm64_ventura: "da6d961c10c3235d680bd60128535dc26638355326e7d7a41b2e9205b534be5e"
    sha256 sonoma:        "a10d71f7205684010cf72602145a126e69d16a7c32749ab9c6847045bd81db2e"
    sha256 ventura:       "a58829da652b3b43c52af964bced191d6f27a92303744ccd07b6fb3e51b2143b"
    sha256 x86_64_linux:  "1a87d774068b14ea9fa2ed30baf30107d2d06839b5a153b2ab285c49be54e874"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libomemo-c" => :build
  depends_on "pkgconf" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

    system "./bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", "--disable-silent-rules",
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"profanity", "-v"
  end
end
