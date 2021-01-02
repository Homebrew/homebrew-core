class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.10.tar.bz2"
  sha256 "d1bba93d6ddacadb5e742fd10ad732727edb743524de229c70cc90ef81ffc594"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "ab87185c1c9276cf74a6c060a6f9d7f32f3012e581da421277d9851d860cc921" => :big_sur
    sha256 "536270c05516a916e48c80f79ffe0afdfbbb7a30558708c7692a9080707693f6" => :arm64_big_sur
    sha256 "60284df0084d62e48620065570b21aa97fcbb0f03a19cb4cb6b94e6dcec822b3" => :catalina
    sha256 "c1608ba36ea14c920193a418bb8d5cf101c4a4f4e12b59a84b52a87ef993329e" => :mojave
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
