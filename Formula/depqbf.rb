class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.03.tar.gz"
  sha256 "9684bb1562bfe14559007401f52975554373546d3290a19618ee71d709bce76e"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "432518e2ccee50695a9e79b4fe558142d78945ef96fcdbf7cccf090d72ec6543" => :catalina
    sha256 "210b2363035bf7772b275036b26938a8a286da0ddbd93d29a72cbbcb16237c23" => :mojave
    sha256 "7c956f3b4e86d6f60e90dde3e25f6b5ce75f2ba75e756c9e4dd6debe46d2ddea" => :high_sierra
    sha256 "fea1eb8ca62fccc5ce43b0a645fb67feffbf97c5a343d0ea6c9a015c37e24ccc" => :sierra
    sha256 "3229005d870984af6beee544d5178094fc859525bd96552ac42301860c175f5b" => :el_capitan
    sha256 "2e56b8bac22dbf77677e825ee6242fea35545c2714859c4f22872c1c0fb056e3" => :yosemite
  end

  resource "nenofex" do
    url "https://github.com/lonsing/nenofex/archive/version-1.1.tar.gz"
    sha256 "972755fd9833c9cd050bdbc5a9526e2b122a5550fda1fbb3ed3fc62912113f05"
  end

  resource "picosat" do
    url "http://fmv.jku.at/picosat/picosat-960.tar.gz"
    sha256 "edb3184a04766933b092713d0ae5782e4a3da31498629f8bb2b31234a563e817"
  end

  def install
    (buildpath/"nenofex").install resource("nenofex")
    (buildpath/"picosat-960").install resource("picosat")
    system "./compile.sh"
    bin.install "depqbf"
    lib.install "libqdpll.a", "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
