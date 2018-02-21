class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.25/libupnp-1.6.25.tar.bz2"
  sha256 "c5a300b86775435c076d58a79cc0d5a977d76027d2a7d721590729b7f369fa43"

  bottle do
    cellar :any
    sha256 "de325c897a736519a7d65cf468ca70ef2c62a318459a20b8eb71164765a8627d" => :high_sierra
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
