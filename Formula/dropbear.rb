class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2019.78.tar.bz2"
  sha256 "525965971272270995364a0eb01f35180d793182e63dd0b0c3eb0292291644a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "79774d3d1443ba9e55da281832fdf29c03f7ddf1784de64bc3606c6c36f644d4" => :catalina
    sha256 "0d7b0c71af63164d1024f4b2b21696a32a3e830de04647bec5bd4d8b602b82a4" => :mojave
    sha256 "e8d134ecfb0b2d07d2ec0fe45bf0196b07795d4e96e87d97eda85f67e012c185" => :high_sierra
    sha256 "705e3d23cb78f0dcd9f7bef085d9887823133f1f1e219a6af544a09d339c8616" => :sierra
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end
