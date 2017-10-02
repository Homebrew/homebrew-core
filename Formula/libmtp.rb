class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.14/libmtp-1.1.14.tar.gz"
  sha256 "3817d3e296be8f1bc527385585780e70984e8e0d6a0d00349240d67e3df412e8"

  bottle do
    cellar :any
    sha256 "16766b79eebef88f9bfa18d9a456b2ba2e83f0b3f34fe7b01315b598444438a2" => :high_sierra
    sha256 "4af77826ce6f18d800a15903896f63b72b0d8dcf96e006d515c73410befbe7f8" => :sierra
    sha256 "995f8eed26c66e201b16859754ff2d182b6846c5a04e547dc9c130e4cd335b56" => :el_capitan
    sha256 "ff44d7f06315ac5dd4332495bb726b6dd431e915b7a5d5f37299ceba94a96b85" => :yosemite
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
