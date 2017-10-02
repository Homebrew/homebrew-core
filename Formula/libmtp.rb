class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.14/libmtp-1.1.14.tar.gz"
  sha256 "3817d3e296be8f1bc527385585780e70984e8e0d6a0d00349240d67e3df412e8"

  bottle do
    cellar :any
    sha256 "ea1c31e565d1a64901bb1fd11ad57ed76e3572d2fae6db9d77a348ca628dee2f" => :high_sierra
    sha256 "6f4b2c6338e83015c19e23d15380fed863cb9e56f11933c2239ec05c25582847" => :sierra
    sha256 "3b2aca5b7b96638ce196396686b9ba4fe89199759f4ba88e780da5cde726c0cf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
