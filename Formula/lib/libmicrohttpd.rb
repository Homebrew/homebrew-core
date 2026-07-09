class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.6.tar.gz"
  sha256 "bb5cfcadfc52dbd5eb512d6e2995e0361351c33e97a87aba426d3a4a7ba6cf70"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84ea972b7b818f37bce5c03aff4bc0cca2c426c901c02a1ff98b1a2a300d283a"
    sha256 cellar: :any, arm64_sequoia: "6d7d900cbb61be50f9f66d4e681b1c55e786e0e150c0a07cdba20ba9cc4bdc38"
    sha256 cellar: :any, arm64_sonoma:  "860ab17f972ec4dc932c2398c549b289f8cdc5f22d0d4db4b9ba8deeabaa4fd5"
    sha256 cellar: :any, sonoma:        "f30af826622d16c18d54d0c5ce8d4dffdf527cda704e1e0d2f297c7697f9e2a1"
    sha256 cellar: :any, arm64_linux:   "57fa9496531b9039810da92650542319f90c26d1d3fe88604b16b9a01843966c"
    sha256 cellar: :any, x86_64_linux:  "72e5470dac39a2e40803506e15714c9b6457b1c1cfb66244cf42c5fb40c25e91"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-https",
                          *std_configure_args
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
