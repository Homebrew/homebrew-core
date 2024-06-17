class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "3c6edaa4c1aaf06a4db21ea71e9c8d3f82187e0ace35c9813136c0e1164e479d"
    sha256 arm64_ventura:  "0abe70541f49da406e708d83fda1692aa020c7942b44934d93555da080bcae22"
    sha256 arm64_monterey: "e062da3abfb99bcbba595ffd8a759b3aac43d539d76d57dc26340025c5a25367"
    sha256 sonoma:         "bc25e571d1887a3464dcca4f8d9bdfc10fce9e3e2769ba28b7765c612d3e5f79"
    sha256 ventura:        "6fc7f42a211ebcd9257ba509ea6a9327ce531ad42227c1d59857c468b8adfc52"
    sha256 monterey:       "6f626bcec863159279cca047f5b2e8bf5bcc2dc74603ffd065a8d0ce7c786747"
    sha256 x86_64_linux:   "da7113532893f9b7ff5fefa25c8f58e6aa757b6eec6476747f23ebb1125992c2"
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
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
