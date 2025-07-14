class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.15.0.tar.gz"
  sha256 "4a9f578f750ec9a7c2a4412ba22e601811b92bba877c636631cc3ccc7ceac7fb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "a125f864203c3d6baa3e2498257ac7bae373dd91ac737a0a098d2e9f9d4b1ab5"
    sha256 arm64_sonoma:  "1d902913042d0c15d2b1b151215a68e6e230a7355f95209e39e8ea4d54742e03"
    sha256 arm64_ventura: "50400b9bdf982500f3d76171990f9379fb287f74f31fa4e58d4e3153940c385f"
    sha256 sonoma:        "6859c02911c5f4fee55ac153b0ca88c2aabaa254c61438ec1d4e89c55deeae16"
    sha256 ventura:       "c0626881a455da269346b59f0f2e0fe89e29d42d71a889bcfa7c53976e196f3a"
    sha256 arm64_linux:   "d5cffb20803a839e6cfcb3d21499a3583abcf0ebea350535b7ffb2fba2866dce"
    sha256 x86_64_linux:  "935efcd1f5e57ca74f0874255c7fb78027ff498dc76b894163e7e28d91386f28"
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
