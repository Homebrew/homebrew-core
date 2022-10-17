class Elinks < Formula
  desc "Text mode web browser"
  homepage "http://elinks.or.cz/"
  url "http://elinks.or.cz/download/elinks-0.11.7.tar.bz2"
  sha256 "456db6f704c591b1298b0cd80105f459ff8a1fc07a0ec1156a36c4da6f898979"
  license "GPL-2.0-only"
  revision 3

  bottle do
    rebuild 2
    sha256 arm64_monterey: "eadfed82fabcfb1b645b28af1d2806e7fb53a4dd0d91d2f4966b1d4bc4180744"
    sha256 arm64_big_sur:  "a35f5c451853a1d1a2b90755d9caf6585993b2c3a2a0c195aee4b4ba1b4c736d"
    sha256 monterey:       "263e1f1a669e0144438c9c30d12387766760957520012a1684fc8a329efc6a2e"
    sha256 big_sur:        "ae280a859da1fc099f51e8916c41c2efb07b7fb0ff278f7ce7d1cccb2a132e19"
    sha256 catalina:       "47c2068cd97c3579cb8e2fd9362bb41e85ea5e2312f8924ed65e67721e0c8121"
    sha256 x86_64_linux:   "65e2e052958ee92ca06ebf8d5968b8fe74d11e6c09e06cd0cda7ba53a0b4e4a6"
  end

  head do
    url "http://elinks.cz/elinks.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Warning: No elinks releases in the last 10 years, recommend using the actively maintained felinks instead
  deprecate! date: "2022-07-25", because: "No releases since 2012; consider using the maintained felinks instead"

  depends_on "openssl@1.1"

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
