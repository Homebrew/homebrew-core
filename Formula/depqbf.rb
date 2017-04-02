class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.01.tar.gz"
  sha256 "e1f6ce3c611cc039633c172336be5db8cbf70553d79135db96219e1971109d73"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "3b26eb6dfa10a2297904e3d0024f10f513e3df10fa6f27201c64b31c553893b9" => :sierra
    sha256 "5a4004f64cc0b9a3e4be0d99ddaa51fe06df333bbffea827f80dba70fe8dd28d" => :el_capitan
    sha256 "4019f3d5d76accf7dd6b04cb097b3972baf9de770cd9d0d0294e34360a9cf528" => :yosemite
  end

  resource "bloqqer" do
    url "http://fmv.jku.at/bloqqer/bloqqer-035-f899eab-141029.tar.gz"
    sha256 "f4640baa75ddee156ca938f2c6669d2636fe5418046235e37dbffa9f246a318a"
  end

  resource "picosat" do
    url "http://fmv.jku.at/picosat/picosat-960.tar.gz"
    sha256 "edb3184a04766933b092713d0ae5782e4a3da31498629f8bb2b31234a563e817"
  end

  def install
    inreplace "makefile" do |s|
      s.gsub! "$(CC) $(CFLAGS) -static qdpll_main.o",
              "$(CC) $(CFLAGS) qdpll_main.o"
      s.gsub! "-Wl,$(SONAME),libqdpll.so.$(MAJOR)",
              "-Wl,$(SONAME),libqdpll.$(VERSION).dylib"
    end
    (buildpath/"bloqqer35").install resource("bloqqer")
    (buildpath/"picosat-960").install resource("picosat")
    system "./compile.sh"
    bin.install "depqbf"
    lib.install "libqdpll.a", "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
