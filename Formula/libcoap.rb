class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.1.2.tar.gz"
  sha256 "f7e26dc232c177336474a14487771037a8fb32e311f5ccd076a00dc04b6d7b7a"

  bottle do
    cellar :any
    sha256 "d83c195d5b9acd81c7a91a3115ef8ac9783baefd48cdf63396c74cefcf4ecbd7" => :mojave
    sha256 "0c6f38dbbdca258949c72b8eb9439e72c9f8cdb473de80fc4b2d5996a89d80b5" => :high_sierra
    sha256 "f9577ef79f4c1a7a257d04004cb64802879787bb5b5657a7aa54ab24ee102c20" => :sierra
    sha256 "a8b3fe01f85e8d9345dbe4ceddda24abd244f1b4055abcfef36e73b26e14ae86" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples"
    system "make"
    system "make", "install"
  end
end
