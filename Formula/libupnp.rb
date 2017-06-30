class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.22/libupnp-1.6.22.tar.bz2"
  sha256 "0bdfacb7fa8d99b78343b550800ff193264f92c66ef67852f87f042fd1a1ebbc"

  bottle do
    cellar :any
    sha256 "19af0c05c9f8dda92e2e056cee17b6798841707c62c906917b78d9e9ec53b0be" => :sierra
    sha256 "b0230fef08232c7de0fa8835924f6799baa728568727836b3e054a4a611078e1" => :el_capitan
    sha256 "ad0a51a91b7e3c0d227cfe2caec446e447497179050924695907d6411259e8fe" => :yosemite
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
