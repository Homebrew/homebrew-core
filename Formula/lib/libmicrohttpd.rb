class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.10.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.10.tar.gz"
  sha256 "04bfe8ef75db7d629a33de767599765cecadc56274a39822d5d081030d577685"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4092f5f284ac8a4dfa7c39997599a51b69a195ad54f778dad979f21cd3ac8564"
    sha256 cellar: :any, arm64_sequoia: "6a0394a2fc518aeb47f03be4db534c0413958334cc2602358e67d14266a2ea5f"
    sha256 cellar: :any, arm64_sonoma:  "0786434799f38b2bf7464adc50a53841f988feefbbe7858dfea52acacc5d2aa2"
    sha256 cellar: :any, sonoma:        "cc9f4f8b05f6988ac8e4579ca49ce166be06ac745be24ba96bceb69855f62451"
    sha256 cellar: :any, arm64_linux:   "ac1381dd54534827a3aebeafebbab0c956a73ada7c63c8f289aa96835951a874"
    sha256 cellar: :any, x86_64_linux:  "bf92971a8cb2ed708df379f5c35d7c4ea5fb8fd137cbcdf24c475ca816bd2db2"
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
