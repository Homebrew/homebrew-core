class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.13/libmtp-1.1.13.tar.gz"
  sha256 "494ee02fbfbc316aad75b93263dac00f02a4899f28cfda1decbbd6e26fda6d40"

  bottle do
    cellar :any
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
