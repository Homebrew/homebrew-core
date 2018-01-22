class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2017.75.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2017.75.tar.bz2"
  sha256 "6cbc1dcb1c9709d226dff669e5604172a18cf5dbf9a201474d5618ae4465098c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c69d621d5e75b5890f219f2d9b1f368b63b28a01974e2db1cb06d61fd3a27d6" => :high_sierra
    sha256 "42f20b1d0ef40b052c31487e0127a259743787b43d593b8bdcbfe3eafb5b5f21" => :sierra
    sha256 "4a55b7ea9de69871d141a34662bd3acfd3dd0db9151542ce165f12d0a74db597" => :el_capitan
    sha256 "f6813d3b81b32e7534391f53d521cf3af9f87f3f40b45f63d9a9dd9723540683" => :yosemite
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
