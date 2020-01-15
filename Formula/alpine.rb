class Alpine < Formula
  desc "News and email agent"
  homepage "https://repo.or.cz/alpine.git"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/alpine/alpine-2.21.tar.xz"
  mirror "https://fossies.org/linux/misc/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"
  revision 2

  bottle do
    sha256 "c3df47485dcedfed585bc0dbbb8fcbc2e6eed1494d48cf49a2ee224eba7e659e" => :catalina
    sha256 "fa4a5f8078a26f5390325855dd98eae3ba60ca8c29cdb19ce6828e51862eef00" => :mojave
    sha256 "96c62ab0c3a3f297f015f67add86563a365d77d477a4244588ad2e92d6f95e63" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
