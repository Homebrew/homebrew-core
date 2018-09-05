class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.59.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.59.tar.gz"
  sha256 "9b9ccd7d0b11b0e179f1f58dc2caa3e0c62c8609e1e1dc7dcaadf941b67d923c"

  bottle do
    cellar :any
    sha256 "1986bf010b0a788b015b3af39047711f783ce6c5dcba9a69526203a36deb9558" => :mojave
    sha256 "7c860a1ec7c375a12afc989721d144334154b7d3a45cdc7b1e0e2fdc7bdd2450" => :high_sierra
    sha256 "e4ac52a6a863271805580972734997984da7c338811839838f4022617fae1cdf" => :sierra
    sha256 "c26ff8c09d6e992a377dc5fa74051eb49257925cb3b2580dbf964bb0d836c8e8" => :el_capitan
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
