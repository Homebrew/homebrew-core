class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.6.tar.bz2"
  sha256 "5f544cf79656e0782a03a2cc7ab1d31a93f36d71d4187bd427ade8d7b55370dc"

  bottle do
    cellar :any
    sha256 "ef2fb66ac2b50aa7c759264b097d6d9b101bb8819236c48760510c9965b47e4a" => :catalina
    sha256 "07c82ac4e3eb16d140d01eb9a10fb8960b2223ac47c3655f2bddd3e976d75642" => :mojave
    sha256 "259cfea3988771cdaaf2851daf44ec9b875562faf8803bd93aff5648fc5b6c5b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
