class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  license "GPL-2.0-only"
  revision 3

  bottle do
    rebuild 3
    sha256 arm64_ventura:  "54e838b71b29c3cfc0aadf6e831b54281957f40cc6d7575214c35c4a3b57fa5b"
    sha256 arm64_monterey: "f0e220cd515da16c63ef96c099141f7df34667397c03c3f4c2c083101fd87d75"
    sha256 arm64_big_sur:  "8a503e767b08604fd16d50ae02f776d9913c84d46b8ff76933f38dd9d8bfdcfd"
    sha256 ventura:        "7f1b9eaf7cc143e9d63d68d571ce4b561cb8916469aea8ebb55731bf68c81e2d"
    sha256 monterey:       "772f9d71d742a369f2dd9002fea64f80d64de5cd6de44e2887b806f3824e1a56"
    sha256 big_sur:        "918dc41b952f0ce90b4a66576450298995442a1627c94b8bbe30631942f3cf78"
    sha256 catalina:       "e6b142759a9de3c7bb75c7d4ddcb3cc90eafc758069af693d12f1f50e5cf3636"
    sha256 x86_64_linux:   "c2c770147ee3abd4622580dd7bc6391a0af29a9db2c514e494187150c2132153"
  end

  head do
    url "http://elinks.cz/elinks.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Warning: No elinks releases in the last 10 years, recommend using the actively maintained felinks instead
  deprecate! date: "2022-07-25", because: "No releases since 2012; consider using the maintained felinks instead"

  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "felinks", because: "both install the same binaries"

  # Two patches for compatibility with OpenSSL 1.1, from FreeBSD:
  # https://www.freshports.org/www/elinks/
  patch :p0 do
    url "https://svnweb.freebsd.org/ports/head/www/elinks/files/patch-src_network_ssl_socket.c?revision=485945&view=co"
    sha256 "a4f199f6ce48989743d585b80a47bc6e0ff7a4fa8113d120e2732a3ffa4f58cc"
  end

  patch :p0 do
    url "https://svnweb.freebsd.org/ports/head/www/elinks/files/patch-src_network_ssl_ssl.c?revision=494026&view=co"
    sha256 "45c140d5db26fc0d98f4d715f5f355e56c12f8009a8dd9bf20b05812a886c348"
  end

  def install
    ENV.deparallelize
    ENV.delete("LD")
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--without-spidermonkey",
                          "--enable-256-colors"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>elinks test</title>
      Hello world!
      <ol><li>one</li><li>two</li></ol>
    EOS
    assert_match(/^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("#{bin}/elinks test.html"))
  end
end
