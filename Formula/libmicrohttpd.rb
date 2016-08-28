class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.51.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.51.tar.gz"
  sha256 "3000bb0ba219061f2ea60251b8ea3d5f694e8c6ce1706bbff57e7e24867a23c7"

  bottle do
    cellar :any
    sha256 "ae9c4123fd28526cbde02108794b61a91c524846aa8e03db55cdb584fd4d3320" => :el_capitan
    sha256 "512f91f43c0c80d5ded0249e0a32806ff2a48baa4f0b0069fba3357c2fcd31e0" => :yosemite
    sha256 "7d61de8f44a181c7fe1759e78cf185ceb3491fcb84d290aad387963402eaacb3" => :mavericks
  end

  option "with-ssl", "Enable SSL support"
  option :universal

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/examples"
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
