class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-1.0.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.11.tar.gz"
  sha256 "f227a044b75688e449b58ddedf0582255cc562899ff69f173a8ef76439744b4e"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    manifest_sha256 "3eb6e8436782dd124281bf4be98970a2b1da955f90211d266c861c354f71f46a"
    sha256 cellar: :any, arm64_golden_gate: "65b015c09a0821e595426b073b5d76a8dab536cdb754fc156b035af661dbd2bf"
    sha256 cellar: :any, arm64_tahoe:       "f89b293d974f566933429bc9a7199a82c82208042d490142e94bb64a0b3e704a"
    sha256 cellar: :any, arm64_sequoia:     "e0da7cfb9ae55936c7573c4b0a8d6d5910363e447822d6ec257e3849dcaf99cb"
    sha256 cellar: :any, arm64_linux:       "b53a7ca6cb08d7ee50dfba4076c1ca160f59510c62294b4aa0ebce10cb9459a2"
    sha256 cellar: :any, x86_64_linux:      "069d059dc51518c9e5b77cc0c626fa4d1b52f1def383c4a22b7760b10f969579"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"

  allow_network_access! :test

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
