class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.12.1/libupnp-1.12.1.tar.bz2"
  sha256 "fc36642b1848fe5a81296d496291d350ecfc12b85fd0b268478ab230976d4009"

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
