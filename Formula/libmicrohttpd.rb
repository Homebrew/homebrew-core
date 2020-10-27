class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.71.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.71.tar.gz"
  sha256 "e8f445e85faf727b89e9f9590daea4473ae00ead38b237cf1eda55172b89b182"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4b726d32231d5178a6e9fb1eff7a4a2e27776fe434fb5e40ecff377ac300719c" => :catalina
    sha256 "03c40981973ceca4b9efbe13d28254378fceba98b45470492a9d677595ce1d0c" => :mojave
    sha256 "87f16499f102b9bf25d31bce38bd396d0d09a8517b036ba2ad57bf9ace7709a5" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"examples").install Dir.glob("doc/examples/*.c")
  end

  test do
    cp pkgshare/"examples/simplepost.c", testpath
    inreplace "simplepost.c",
      "return 0",
      "printf(\"daemon %p\", daemon) ; return 0"
    system ENV.cc, "-o", "foo", "simplepost.c", "-I#{include}", "-L#{lib}", "-lmicrohttpd"
    assert_match /daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo")
  end
end
