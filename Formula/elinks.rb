class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 3

  livecheck do
    url "http://elinks.or.cz/download/"
    regex(/href=.*?elinks[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "202ee1461541e8ab6a7a104921afd683bad3f4cca076db1b403320a6d28bb528"
    sha256 arm64_big_sur:  "b8a3fabec047d5aa9245312dc431804cc51f8c4d4651556273e2b288a3ec8e2b"
    sha256 monterey:       "a04ce9e16ae35d09f2e5c88b244551b534d84561d756ec3d19eff62213f9d4d1"
    sha256 big_sur:        "ba722b4af55c647152cfc0093d75df36af2bbe66898b402a10d9dd9e5b652d78"
    sha256 catalina:       "67ab168d9d6d5bb65791d4c432e7e1e0109a09076039d4d6b2addec9219bef43"
    sha256 mojave:         "c48e70700c0ad0c4b66a376e6634417cd84c84de064bad74d384469d8f7597ab"
    sha256 high_sierra:    "219f12e44db5b6e966e2f8999fc1d5553c834b58645531f5167e6031aaa6e89b"
    sha256 x86_64_linux:   "9516a2d7465d75934943b8647965a9bcab62505a55ddf9721518cda1fcc277de"
  end

  head do
    url "http://elinks.cz/elinks.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
