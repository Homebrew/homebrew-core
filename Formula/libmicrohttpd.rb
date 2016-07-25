class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.50.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.50.tar.gz"
  sha256 "d1b6385068abded29b6470e383287aa7705de05ae3c08ad0bf5747ac4dc6ebd7"

  bottle do
    cellar :any
    sha256 "e2672267f1431be3c924ec2f9a99c6c1396e0cd21a2553379faf1e6ba0b48ad1" => :el_capitan
    sha256 "f7a4141e0f89a6934d93a8ed65cb4c59c0c9f9e9e8f408619668f005aa47f9c5" => :yosemite
    sha256 "3a45b0257777cb5639b38ad88800307cd04e7faadedec3efb531a76c6254dfff" => :mavericks
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
