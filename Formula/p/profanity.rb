class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.15.1.tar.gz"
  sha256 "c1e28a849aa178fd1ec5f384b0f8bdd244bce453dc4ef7bb76d0830382fec304"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f9b9d4492654717f9424c1e2f791a7090ca707aa0717890e7817934ad66692eb"
    sha256 arm64_sequoia: "c0b93ead858fcc1b75252816960ed823229b1a26e13c23acf2fd9e6cf3e319aa"
    sha256 arm64_sonoma:  "dfc08a97ed654765ec4e180b4be29f27997f44460c8b8cb00a86d5bd53f3b886"
    sha256 sonoma:        "8992d942be22bb4ea9907fd43400795c022881ce0bca0502a80396eadfe90a8d"
    sha256 arm64_linux:   "6d086793018f24cefa935a296be7b985a5fd749f16ed91f20f68b258c061fe50"
    sha256 x86_64_linux:  "d71c0460eeeb71db2e81733d8745386265154e77329080a71d26733a5b58ecfe"
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
  depends_on "python@3.14"
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
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

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
