class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.2.tar.gz"
  sha256 "df324fcd0834175dab07483133902d9774a605bfa298025f69883288fd20a8c7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "744bd620cfd4c01fdab40a0b91d689994d549ce6f31f54a785c968348f29e089"
    sha256 cellar: :any,                 arm64_sequoia: "b7a29d626f13b7c07748d4100cf0c0f9703e1a719d8b1afc80854e7730cdf0ba"
    sha256 cellar: :any,                 arm64_sonoma:  "aea54f52d2c8721371f8607573ca73c7a4416ac7403ea6bd9595e3a894e477a9"
    sha256 cellar: :any,                 arm64_ventura: "5f8e0e18ec4d2e5e20035c158491e0f2ae8ba7df895d6c218694e21bb9830eeb"
    sha256 cellar: :any,                 sonoma:        "156e4a7aff40fbe887ee8bb29c5a9d5461344f6691e892549a3ffb9e6bcf77bf"
    sha256 cellar: :any,                 ventura:       "c9e8f4ed223f6be8e4e50749728eebf986e855dda1dccaf2727530cb200623f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6d3a71cbb43a0ab2f6bbe97a6355ac7a4524386a39051e90e78367da7914c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4432eb01656c407982be598afc6c27aad4aeb5ad92d33db646d0ca38ad15518"
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
