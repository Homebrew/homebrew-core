class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.77.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.77.tar.gz"
  sha256 "9e7023a151120060d2806a6ea4c13ca9933ece4eacfc5c9464d20edddb76b0a0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "db5805160eb11ac4c60b5de2e9b29ac0a9f2a35db53cc0fc9b9a5c8d9dc6ba9c"
    sha256 cellar: :any,                 arm64_monterey: "d9038f31539af0dd9d376bfa304f30c755c9c61ca4f751048a4e02c81fb406f0"
    sha256 cellar: :any,                 arm64_big_sur:  "a1ab5dd724062a0931c3c8b2545c6a282114b662a653b48dbf50b16ec26bb95d"
    sha256 cellar: :any,                 ventura:        "1dbaac9c6d165536ff5a7834227305e6aad50dd8c6583e1575e1b6eac3ca346d"
    sha256 cellar: :any,                 monterey:       "117479b8d61630e7eefa071e1eb586af7af8d9db1dd4c78a34343a37c1d76d32"
    sha256 cellar: :any,                 big_sur:        "c5a7c2d00dff286ff8c70c757b609a4c8f085019955885ca99da0f8537763409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d77426c489b76f16982e5d2e12ac46d96011d65022e82e03e8e220aa9332c0"
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
