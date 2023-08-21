class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "8d5cef943b569c324bfa8de07fa5770ca0ef932ce3feeae68cf25d3f08ed8631"
    sha256 arm64_monterey: "8a1b33ced9dc9a01ff881753f9bcc60cef4a3117183bcb27c5571ebfdc908bec"
    sha256 arm64_big_sur:  "eda1ac7caca301457e9af1d70c68282098d59f02c417c31b7168cc19bdf1171a"
    sha256 ventura:        "c3dd576320d0639dd3c2ce4641aa5390e52e22ec429828798cde4fec1cd07b7d"
    sha256 monterey:       "f2802b8a422f883cdb68f89d5dd9550dad5861840343f729b6ef202a6a91e0a3"
    sha256 big_sur:        "2b5e313f5cb796cd54e2e0edeffbefad53881cc63233c57c8b3be7b7662a99f4"
    sha256 x86_64_linux:   "073f126f659a24c7e5ca76fc0dafff472f98a131802cb6537a1133c45408a0e6"
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
  depends_on "python@3.11"
  depends_on "readline"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

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
