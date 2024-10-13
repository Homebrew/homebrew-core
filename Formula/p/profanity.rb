class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia:  "9ee78fe1e4f7ae13fa28a0edb7f2c4548c0f7e47acf6ccb7a1d9a758396af95d"
    sha256 arm64_sonoma:   "796e4f6d0df72b4fba98c6767294a0c34126e507178f62c059305e1447b1d57c"
    sha256 arm64_ventura:  "f3af3a72068af54c2a5dfed25f8b4974d484e2a1c6c04782e452999f03b04a7c"
    sha256 arm64_monterey: "026ec8f456effae8170417422b863ffcc7defd02f660f03878522e8aa73fe467"
    sha256 sonoma:         "9daaa88e4367a56347e0fe2697f8a838452ca069ac92d37aaa4161db13b59c5c"
    sha256 ventura:        "18296f861b95ef07102130df116f8da3a442fe038524f3a235cd95a423891368"
    sha256 monterey:       "fb5dc8733a2fe8c043c3a77a665af9c9a30acde98d1e74d2d195b8a2699fdaa4"
    sha256 x86_64_linux:   "b5a3eda754ad116b984759d462ec0a691a74005e262c234d7bd5b812c66c2bb5"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libomemo-c" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.12"
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
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

    system "./bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", "--disable-silent-rules",
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"profanity", "-v"
  end
end
