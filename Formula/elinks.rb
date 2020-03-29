class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  revision 3

  bottle do
    rebuild 1
    sha256 "67ab168d9d6d5bb65791d4c432e7e1e0109a09076039d4d6b2addec9219bef43" => :catalina
    sha256 "c48e70700c0ad0c4b66a376e6634417cd84c84de064bad74d384469d8f7597ab" => :mojave
    sha256 "219f12e44db5b6e966e2f8999fc1d5553c834b58645531f5167e6031aaa6e89b" => :high_sierra
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
    assert_match /^\s*Hello world!\n+ *1. one\n *2. two\s*$/,
                 shell_output("#{bin}/elinks test.html")
  end
end
