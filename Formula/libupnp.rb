class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.22/libupnp-1.6.22.tar.bz2"
  sha256 "0bdfacb7fa8d99b78343b550800ff193264f92c66ef67852f87f042fd1a1ebbc"

  bottle do
    cellar :any
    sha256 "9396b311d0ccf64bce92ae68ba54b50614e2e694293c17033411abef3fad45f8" => :sierra
    sha256 "b8799e64ad5dcb2b5fc61b3365815affc8c33b5493f48cdf185445942ed0e639" => :el_capitan
    sha256 "1778385bedb76e9d6fb344682503ef95c9fa970bd3f78e2c7a6d8c30f2ddc263" => :yosemite
  end

  option "without-ipv6", "Disable IPv6 support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-ipv6" if build.with? "ipv6"

    system "./configure", *args
    system "make", "install"
  end
end
