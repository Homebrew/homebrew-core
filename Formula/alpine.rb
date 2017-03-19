class Alpine < Formula
  desc "News and email agent"
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"

  bottle do
    sha256 "54f70a9e4c99187db5c75e0aa0dad06726de997824e306ba625e95466bad8b27" => :sierra
    sha256 "ac340d52fc2055c7e78622809750274fa9957bb1f3d7a635a29f46416a312d85" => :el_capitan
    sha256 "551758443501811d21f90d3fc4f29a0787cca2409e9413138c9b8fac96395da0" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
