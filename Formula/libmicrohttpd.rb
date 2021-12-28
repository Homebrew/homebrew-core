class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.75.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.75.tar.gz"
  sha256 "9278907a6f571b391aab9644fd646a5108ed97311ec66f6359cebbedb0a4e3bb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "27173d173ac9236460f76ae869714b343de910778910778bd4f71d499ee77aed"
    sha256 cellar: :any,                 arm64_big_sur:  "0cdce2d115093cb02248dcc267f64c042f0ff970006117b36398a47ae2cf19f2"
    sha256 cellar: :any,                 monterey:       "f609d60ca98f6495b97b3aae1a6c11c915f8e728dbf3c190b3227a964743b82f"
    sha256 cellar: :any,                 big_sur:        "c572f415dcb2407855683e5345395dc31532920a1f7520de5d972657258b883a"
    sha256 cellar: :any,                 catalina:       "ba52cc7d9ad91ae2d64afdb956c75d946d80bcfc82a996705298e5896ee8c95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a47274d9b84b32a2c7b3328a7201aa86d8399f4e00941f5461498f527fb44ae"
  end

  depends_on "gnutls"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-https",
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
    assert_match(/daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo"))
  end
end
