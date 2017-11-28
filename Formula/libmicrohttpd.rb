class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.57.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.57.tar.gz"
  sha256 "dec1a76487d7e48ad74b468a888bfda1c05731f185ff950f1e363ca9d39caf4e"

  bottle do
    cellar :any
    sha256 "bd5e172b2cd386f61292bed10d4023b0c58b9b389a4abe0317bb8278e373d75b" => :high_sierra
    sha256 "fa246ec8a891bb8e2d30d370481bdafa50a655e40a7464abc108bd439c4b628b" => :sierra
    sha256 "fba444e775c81f2a790f1644f3243aa79d0bf9a6944fb56907968233d2106c2b" => :el_capitan
    sha256 "67bd7b02c040618e6d041d4e6969b7abbb7f193b2cee2514701f86239ce1e8f2" => :yosemite
  end

  option "with-ssl", "Enable SSL support"

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
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
