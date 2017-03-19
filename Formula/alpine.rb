class Alpine < Formula
  desc "News and email agent"
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"

  bottle do
    sha256 "40e1bb1dca0c3f775bd1ae01abb41a1b0034d2c646b3ccfd169a3d089f94af7a" => :sierra
    sha256 "730553f37f597097bbba910de04dd5b9327d5b5a920c26f29406eca2d31f540d" => :el_capitan
    sha256 "cd774d63bf4327c4109a6b97fd7189f9618d53bd608bb314101f4880368f7662" => :yosemite
    sha256 "b35c3667a183c86dfa769e1d9e53669524930fda371422ab1c8519d3d807b8d5" => :mavericks
    sha256 "8f52d4ebe9e445ec975cabdd74c4a48cef80eebb21f18c33644e99de1a6d2173" => :mountain_lion
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
