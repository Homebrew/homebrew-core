class Alpine < Formula
  desc "News and email agent"
  homepage "https://repo.or.cz/alpine.git"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/alpine/alpine-2.21.tar.xz"
  mirror "https://fossies.org/linux/misc/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"
  revision 1

  bottle do
    sha256 "73d6ba0c5623c94d2434fbb7d64e232faff22ad4a2d0352f32bcf6e1c2b33d5b" => :catalina
    sha256 "63000d10c5caaffa13d36c1c9d798cb421389d796391ee2cab33f586a53f59cc" => :mojave
    sha256 "cca98c8f35a89f926ca47d88e1b2a1b845233518962a80fa71d6427e9007364d" => :high_sierra
    sha256 "c60a2e6a4d4de41dfd17a37497fb24eae9b8c07ce7e55fa1726765b6ddac20d6" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
      --with-passfile=.pine-passfile
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
