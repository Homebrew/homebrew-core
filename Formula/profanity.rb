class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.13.1.tar.gz"
  sha256 "2b5075272e7ec9d9c991542e592b1d474fff88c61c66e7e23096ad306ed2c84a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "fcfcc39a0046f3dea14792a29b17c1f9975ae8ddf6e9e0aa6c290447c77f585b"
    sha256 arm64_monterey: "056130e0175fe061171aa23c0aba2626987020a62162bd49c28d3b2ded79e6ad"
    sha256 arm64_big_sur:  "2d6420972cfb0ab56b968245d67d557e5f4b08a1378c2277979ff40ba9fde266"
    sha256 ventura:        "b3ca86b0f0e3d8e457f9b1acc436da3ce6fdd036c25a64efd7c85d8c6c2013c5"
    sha256 monterey:       "e942a19b775d15b1c160c5f3b0924f1e93249309fa1a54f8e96c2a6b0c750d86"
    sha256 big_sur:        "2a12f1e8209b0078713bb71e54469a6a8a3f8bbffe37a59f06541f34cf08a800"
    sha256 x86_64_linux:   "22412eee0a04d94e03ea8871df887ab99cbc1a93d7d6b10843fd96588bc6d741"
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
