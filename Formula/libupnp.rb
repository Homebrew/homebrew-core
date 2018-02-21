class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.25/libupnp-1.6.25.tar.bz2"
  sha256 "c5a300b86775435c076d58a79cc0d5a977d76027d2a7d721590729b7f369fa43"

  bottle do
    cellar :any
    sha256 "cbca37b45cb652c73d4c5ae0ae087338bb4c606f5be4306c5d998c39c382bb4b" => :high_sierra
    sha256 "b870845572dd6d11ed90fedfb367bbd53066f6b9c90e522b97ce88ae53ccddfe" => :sierra
    sha256 "9b660881232e6ce94a375962c1df55f179f69335c7d11907b9a9c5dd81693360" => :el_capitan
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
