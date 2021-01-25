class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.18/libmtp-1.1.18.tar.gz"
  sha256 "7280fe50c044c818a06667f45eabca884deab3193caa8682e0b581e847a281f0"
  license "LGPL-2.1"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "5ebeb1696d5c7af72cb4a14f905dbde2cd871334ea392e7e8ff0305159c09aa1" => :big_sur
    sha256 "4af12c090f3214200d4a37b9511c1fc1ba0269b40f26c0e9c45c4dbfe2c64474" => :arm64_big_sur
    sha256 "9b305e731b8d8608b688bb5c8bb98192d4879eb944fd4b08c09daadf367b68fc" => :catalina
    sha256 "e4c497e80277170743a4ff8ddde06687a01f3afb053088b921b8399796f630ae" => :mojave
    sha256 "704cd1e718e42dc9284ca020a11c1788d8a222cb8a4ca939d6b289cd17cf86ad" => :high_sierra
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
