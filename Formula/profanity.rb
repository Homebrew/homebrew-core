class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.13.1.tar.gz"
  sha256 "2b5075272e7ec9d9c991542e592b1d474fff88c61c66e7e23096ad306ed2c84a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "e73f0f153838ffe9232e70fbff7e6f23383826def85ada552c6a09767a92c188"
    sha256 arm64_big_sur:  "623d2b7628bc2f8d4edff8304f111f04a84ed50bfbec080398673e5e54fda9c1"
    sha256 monterey:       "d8b176edac7c2cf37e38d3f5a0b5b0845ed31ab9f8c3da64fed3da0e8b3b1fa7"
    sha256 big_sur:        "b4f024ef69564765f476b73e2f7f58956e93d2e429c249d6c13f65e7412d02ee"
    sha256 catalina:       "c1e868418d5c3fd09cb6d24bcffd35717020d9a7f45f1d8b3105caee64e4dcd1"
    sha256 x86_64_linux:   "b6df6521b509a704c7bc5d36c2549c39e82ad71dabfe877c7eee3efe96470775"
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
