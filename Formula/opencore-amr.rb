class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "http://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.4.tar.gz"
  sha256 "029918505e6a357b2b09432c7892a192d740d8b82f8a44c2e0805ba45643a95b"

  bottle do
    cellar :any
    sha256 "6412c1b3a927ed533d8dac323320c1d005eff643ede06070915ddcdd68975273" => :sierra
    sha256 "2434237ad9e130eab8f89b4b3f7fb7d299c216bb28b344a47460a93180025eea" => :el_capitan
    sha256 "b4373425e5d5ad32cfda4b98c17946a61a78d1d6001edd6bc31f17546d881036" => :yosemite
    sha256 "b7d22ef690bc40dee36e90d747cfb108fd69b6cabd3b6a4593767fb49c553aff" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
