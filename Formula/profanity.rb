class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.13.1.tar.gz"
  sha256 "2b5075272e7ec9d9c991542e592b1d474fff88c61c66e7e23096ad306ed2c84a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ed139220e7ccbc28492b21a36b46938ca0a0eb9726d12a5b5a5ec2732a70b2e9"
    sha256 arm64_monterey: "0445e9095f46d2feb9d4885addcbe3776d0582eebbf69a1ed6159323c31a46b7"
    sha256 arm64_big_sur:  "fbc2566e1def33062a2d48435900ac0ee347ae5e3b9083a5840afdedbfff6c3f"
    sha256 monterey:       "dba2f230257a1bac9b5a3667f8a339bcc4bd1eaa6ebd22afe798bf078dbe0e77"
    sha256 big_sur:        "8b7edbbab26d273e2acb2ce927c796e3cd25b90c0d9c49a4f9788eed6049688d"
    sha256 catalina:       "234b9a17bc5bcb40fa28093cb430f613c3e4b6dea64ab58abfe18fc2840afa7e"
    sha256 x86_64_linux:   "534112eda8a5e3a78ef8b1fa301fef91c001ab73e5e57eb128ce9f2418f2bab4"
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
