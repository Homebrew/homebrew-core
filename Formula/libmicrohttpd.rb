class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.76.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.76.tar.gz"
  sha256 "f0b1547b5a42a6c0f724e8e1c1cb5ce9c4c35fb495e7d780b9930d35011ceb4c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f03463c98e01db7f4b03ab50d8b9a3c5356f94d65b51a2af0f1027bab40003e"
    sha256 cellar: :any,                 arm64_monterey: "7f5930a6188d53f81ca79ede1ce73cd4b9ef6af1b332e82ada9aface1b1f0996"
    sha256 cellar: :any,                 arm64_big_sur:  "7f7a4a1e5563ff18adaaeb607606c79e5b28ce1ffda59a99b408ac99ababece3"
    sha256 cellar: :any,                 ventura:        "c382c04a59ec0b24cd29f8666a9c6a4fa0dd271bd825ec31eba4a3a0393fcc57"
    sha256 cellar: :any,                 monterey:       "9d5255e5f3ca2faee06c464465fa4665c7c079050537d08b5733c38c3491cda6"
    sha256 cellar: :any,                 big_sur:        "6af15aef5cfe18d9fec669a28cded546209ecdb62eaef37040b77cf7f78e18c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c868e51274f6e5ca2d4fbbd3745ab40043538bdfa3c85914fb89688b8c4449fe"
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
