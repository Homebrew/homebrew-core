class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.75.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.75.tar.gz"
  sha256 "9278907a6f571b391aab9644fd646a5108ed97311ec66f6359cebbedb0a4e3bb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b0d7364c3c44c0efa904dcc80f7beb63640454a34cec5d35c84614e3305f57b"
    sha256 cellar: :any,                 arm64_monterey: "719b89039fa6d2a7bf46e3e41d092854fcf7a2192bff60dcc6d307416f67758d"
    sha256 cellar: :any,                 arm64_big_sur:  "0ca1f7a5751af784f3ec1afc2fa85bde3487be08a7b5fc17a07335c0d399b13c"
    sha256 cellar: :any,                 ventura:        "7ebbaab537451e21141c40b20afc157d187a4ce0297ecff798256375cfee7eb1"
    sha256 cellar: :any,                 monterey:       "96833590a2b4173f35f25eaf23c589f856eaa2780fabd66f646335508555a95f"
    sha256 cellar: :any,                 big_sur:        "a540b019ab53255a0ddec65ddc85c5d891f75a51305b63c81808925c55556b50"
    sha256 cellar: :any,                 catalina:       "4b7505f1f572a3052d356f639d7d25cb77c1b1ffae9378b4bed3789d70778986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed9838a0a467888b3012b2c2979accdb9cfc27422c5ffd769408e3afe0cd5c5"
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
