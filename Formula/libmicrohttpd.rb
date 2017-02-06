class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.52.tar.gz"
  sha256 "54797f6e763d417627f89f60e4ae0a431dab0523f92f83def23ea02d0defafea"

  bottle do
    cellar :any
    sha256 "44580fceb6477e2f4fb6a4d4659a48b41c5b5b8bf6477a1679467830dfa0324b" => :sierra
    sha256 "ed10cf7c59d160631d12c558e6debaa0c31a4cef7946a479af95d6be076f8a6c" => :el_capitan
    sha256 "0cbd499c1d9e7126dddfcad9817ac442904c3fdde416c3c3b9f545566d6be58c" => :yosemite
  end

  option "with-ssl", "Enable SSL support"

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
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
