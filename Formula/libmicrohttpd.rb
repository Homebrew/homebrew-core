class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  sha256 "54797f6e763d417627f89f60e4ae0a431dab0523f92f83def23ea02d0defafea"

  bottle do
    cellar :any
    sha256 "cd724c3c098d44924a9f6345b75a45e2eabc6690a5c1bc6744a031e8db51da76" => :sierra
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

    # Remove for > 0.9.52
    # Equivalent to upstream commit from 11 Nov 2016 https://gnunet.org/git/libmicrohttpd.git/commit/?id=52e995c0a7741967ab68883a63a8c7e70a4589ee
    # "mhd_itc.c: fixed typo preventing build on Solaris and other systems"
    inreplace "src/microhttpd/mhd_itc.c", "(0 != fcntl (pip.fd[i],",
                                          "(0 != fcntl (itc.fd[i],"

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
