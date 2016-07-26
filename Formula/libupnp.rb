class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "http://pupnp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.20/libupnp-1.6.20.tar.bz2"
  sha256 "ee3537081e3ea56f66ada10387486823989210bc98002f098305551c966e3a63"

  bottle do
    cellar :any
    revision 2
    sha256 "8300a8d89071475837506bea964cdba143144186dad0943e4d8c722c799e3857" => :el_capitan
    sha256 "29d9a4c05dcfd083b3538110d7a5089143399cb05670574761dda81d3b9c8ac7" => :yosemite
    sha256 "ac9e828723689c2d91b6f046baca02baa1a653caacfe071aa5add056e1f2381b" => :mavericks
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
