class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.5.tar.gz"
  sha256 "b46d00f58efa6f497b97d2e782c4ee66301d412ddd855dd3068518b3a2cd3ea2"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd84cc41c84e505be8a957788a3f2993c082d5c7c29e68ee951228bcd79374d9"
    sha256 cellar: :any,                 arm64_sequoia: "291e7f43b1f252816c7daa42c69079ca3022ba778d1381768c42301b269e0286"
    sha256 cellar: :any,                 arm64_sonoma:  "c1959ffe509c181f211be15b8cef3c5ffec9ab8985354cb56b6321c0760d9e12"
    sha256 cellar: :any,                 sonoma:        "c889f12e20ce446ef65784e28f3135eedc3c358d69963dab068331a1345a7eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8ef804898c01fa619655d9b62e3754eaf74421322989dbf24dc6aac702ac5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9901822c18a24a632deacd02755e0e20936eb5a5a9134dadda3b844d8e203ed9"
  end

  depends_on "pkgconf" => :build
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
