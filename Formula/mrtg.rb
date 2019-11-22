class Mrtg < Formula
  desc "Multi router traffic grapher"
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.7.tar.gz"
  sha256 "9b94cb268fb15b0304ad3bb3ec92b9a8a16dacfcee72baac19298224a2c332c3"

  bottle do
    cellar :any
    sha256 "cae75a7387673aa555bf72112a1a00e24f9c2c87f87ffe2fcdf839c6b31a95ce" => :catalina
    sha256 "cca3b58b58a453636d67bd041f56df487ce86eb7f592178bd9f8745e35e0f5f0" => :mojave
    sha256 "8a76630f04f1c8b6883d7621cf9c72456e22fa5206a8b2b3eb6527547d048fbb" => :high_sierra
    sha256 "71561d0dbd12007514597dc85bf8ecb5e76e32f0feb35eb126b0998a30db49c8" => :sierra
    sha256 "0d434588f3d22e55db11fe23baa82a5e1a4a8ccbcab84dfd74ddc1a0dafc085c" => :el_capitan
  end

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end
