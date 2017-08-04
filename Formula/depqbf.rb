class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.03.tar.gz"
  sha256 "9684bb1562bfe14559007401f52975554373546d3290a19618ee71d709bce76e"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "3b26eb6dfa10a2297904e3d0024f10f513e3df10fa6f27201c64b31c553893b9" => :sierra
    sha256 "5a4004f64cc0b9a3e4be0d99ddaa51fe06df333bbffea827f80dba70fe8dd28d" => :el_capitan
    sha256 "4019f3d5d76accf7dd6b04cb097b3972baf9de770cd9d0d0294e34360a9cf528" => :yosemite
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
