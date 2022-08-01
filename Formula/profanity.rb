class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.12.1.tar.gz"
  sha256 "e344481e7bf3b16baf58a169d321b809c4700becffb70db6f1c39adc3fad306e"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "4b6568e1bdcd0dfbfc90ddaa808073aaba70daacb1d001cc1cc175a7726a788e"
    sha256 arm64_big_sur:  "a7034698ee4bc67b93f623a14fb1e453b5634dd084c4e2433622ebd4a41c0122"
    sha256 monterey:       "50859d21f0c8000c4746e5255aa0c68bc5bfa8e2f5aeae14bf2eaca934853443"
    sha256 big_sur:        "56fc2c696cd99078ed1901b2461908d6cb583d63eaaff8639791d07cc08ddefe"
    sha256 catalina:       "083885d92e7760418730e4c9c689f59c095be42829095eb0d33410930411deb1"
    sha256 x86_64_linux:   "ff699bdd2cfda2cb38586839cd70617debec5839ea2216621fa4bfbd2f443065"
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
