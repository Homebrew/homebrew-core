class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "https://udp.github.io/lacewing/"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1
  head "https://github.com/udp/lacewing.git"

  bottle do
    cellar :any
    rebuild 3
    sha256 "7eeafbbc871a1a129a8d9c049b682ba7b4029964cf091656ef93d69c00bb4919" => :mojave
    sha256 "8278d62a461051bf600ebf39856ac5f53d8f0a0b47079c57e1dee933208b66d8" => :high_sierra
    sha256 "607ed27f0e7c618fc937a9bb7c5f2727e597d0e3fe26af613e2c152f0a13041e" => :sierra
    sha256 "8521b6bdb48855fb5e87d3354d65db5d476c56b416807145c9e9f05500ae91d5" => :el_capitan
    sha256 "8df9b4bab55b90fe7892187dd711aa40898ff83c6b66a02a18bdbef87ad2fa6c" => :yosemite
    sha256 "af978e720eafc9106c8dcb9391b341ec984339fd87db419f54229c5ae3a03d8c" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # https://github.com/udp/lacewing/issues/104
    mv "#{lib}/liblacewing.dylib.0.5", "#{lib}/liblacewing.0.5.dylib"
  end
end
