class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "http://pupnp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.20/libupnp-1.6.20.tar.bz2"
  sha256 "ee3537081e3ea56f66ada10387486823989210bc98002f098305551c966e3a63"

  bottle do
    cellar :any
    sha256 "c96f0641e9221bc9565e6cbcd5340a644d36a24414a451ef65b0b6517e89f4b5" => :sierra
    sha256 "cf33fcf4bc1b0d9ddda8d998f09d31388a4043ba863af0a5361ab4187bba54b1" => :el_capitan
    sha256 "d177cf09083fd9c9d348123e26e549a8461b8e38c89cd67eacbec67af60b476f" => :yosemite
    sha256 "f4dd77cf20dd7a6306b784350f9995aee53c89e11f72839bb70b41f7b167d5d2" => :mavericks
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
