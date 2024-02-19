class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "244bfea9088b20382b2fa6d094b207f711dd0519e157b6fc9ae94f2da6011478"
    sha256 arm64_ventura:  "5b0b3b659be206020c43262e5afecb2c4c028b5349ea92fe04ef91973f56232c"
    sha256 arm64_monterey: "c9850c6da8adc21e93fed0410bf2dd1a508e26530260c0a357c4d8ef8a350b88"
    sha256 sonoma:         "3598757d7025dbe0db9b71b92445618bdbed930aed763d98415e42292db9bd97"
    sha256 ventura:        "c8e2c1ee834cbb44c56c43b0cb32b4ac01815b0cf8b9a84daaaf707ac8f9dfb9"
    sha256 monterey:       "ba6a50ab342e1108ff971a101ed33c96a00dd437391b8e04b49629a7833a8bdc"
    sha256 x86_64_linux:   "3e71d2099b2aacdcffea417afbfb1f0e0058ffc325ab17880c79c4080afeb971"
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
  depends_on "python@3.12"
  depends_on "readline"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec/"bin"

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
