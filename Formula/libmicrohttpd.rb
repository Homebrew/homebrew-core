class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.72.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.72.tar.gz"
  sha256 "0ae825f8e0d7f41201fd44a0df1cf454c1cb0bc50fe9d59c26552260264c2ff8"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8077a7455cced7a3aa3da7d3f9a2cbf5626e7ff52f18e0f9518646a224b5d049" => :big_sur
    sha256 "100b76ee0927bbc78ef71edf61a5f1df115aeac0dd37ec22169f2b4c83b65451" => :arm64_big_sur
    sha256 "1d4ef28fe8b92ca4243f35c7caa5d586c7b4cb7d2eac7f6d408b50f58478d5c4" => :catalina
    sha256 "0880e89689cbda10d2586d4c0c46ab405dfcfc3b569ad69e855cd238f5772a89" => :mojave
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
    assert_match /daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo")
  end
end
