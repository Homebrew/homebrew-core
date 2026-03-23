class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  license "GPL-3.0-or-later"

  stable do
    url "https://profanity-im.github.io/tarballs/profanity-0.16.0.tar.gz"
    sha256 "1f2e36a081cd299173f1c12b64b1cef971063e67bf226fb3f7048f2e67bd6a70"

    # Define `prefs_changes_print` outside of `prefs_changes`
    # https://github.com/profanity-im/profanity/pull/2090
    patch do
      url "https://github.com/profanity-im/profanity/commit/309c0a64a7636770f6aabe7c55c00a0d0a77031c.patch?full_index=1"
      sha256 "2f85e7a8e3c503fecc63959e978bdb99cafbceb1b2687952d52088a352de3aed"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "669b57ae421eea14e623d6306d16f62f8a3e7e5ac52fc69b6283d4a15f79ca9d"
    sha256 arm64_sequoia: "477f46a2c063e66a2b912ca2788500d6647072933488d7c4f57c49152f53966f"
    sha256 arm64_sonoma:  "20dd11d5c66e8b6470b58c8ef658144c2a02cfbf8498ec265337052a4b51d435"
    sha256 sonoma:        "7d238042c8a6f2c67b8ff2bbf60e4e2902212976c613257fb2cd5adb39c6f061"
    sha256 arm64_linux:   "bbfb37674269d2c6acd616e77c6022e346181b7093fb30b05e1c60343d48dffd"
    sha256 x86_64_linux:  "b041c981823cfc9d4bb96e6d78b49a040834b1cbbb6bdf5e759ec9b5b4824ee6"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
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
