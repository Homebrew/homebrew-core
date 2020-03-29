class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.12.0/libupnp-1.12.0.tar.bz2"
  sha256 "1bda3939976a9a2901382233db39379ce993b59a0e7fd0dd781212a44a9b44a2"

  bottle do
    cellar :any
    sha256 "64f8a5b5aba6881e7729c1648a548aac8eed1b15dc3efb6cd8b610dde0cb4e96" => :catalina
    sha256 "eac1001e055b7c658748548812ff917b466cd48722058c853a332cbff19201cb" => :mojave
    sha256 "8b94bfb79baec4a60f7a0645938e58fff59067531ad80bb00381c73453435c56" => :high_sierra
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
