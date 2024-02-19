class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-1.0.0.tar.gz"
  sha256 "a02792d3cd1520e2ecfed9df642079d44a36ed87167442b28d7ed19e906e3e96"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a4186c771da28f3c8fa959acc200388609c07e7b8a78cf52f809355a11b0874"
    sha256 cellar: :any,                 arm64_ventura:  "118a6807bfa78955b68d205daafee58b4ee0c84d234eadff9902c8a4f6b31cef"
    sha256 cellar: :any,                 arm64_monterey: "ee43b56c13e1036a2db4d2529237261d9d8ba97c5d241d4cc6c6d76999dc8f86"
    sha256 cellar: :any,                 sonoma:         "7f5d33cdd8b5851741ed4d45fa14f5d0c95f66b7d97870302ff9c791a8f84551"
    sha256 cellar: :any,                 ventura:        "71a7d3c0c76acbb4d2cf644bcf153fc82779bc3c894ba59dd2288b7ae69f4cd6"
    sha256 cellar: :any,                 monterey:       "697a2985bb9e763fa70a2f34d0e031fb8111185c608c6c7c2be355aa96a64958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc78a8e64a4b97b1a469f147dddedcdfa2cf163509280cc3bc5758c0f5a83b6b"
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
