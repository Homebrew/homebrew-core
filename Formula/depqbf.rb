class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.01.tar.gz"
  sha256 "e1f6ce3c611cc039633c172336be5db8cbf70553d79135db96219e1971109d73"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "8d500845a553dafeffbc2ac3a34d15d05f84e39707141ad6eddf30dd68b80c8a" => :sierra
    sha256 "7c0b8ef336f9d2bac14e11f0ca838620428376ba4b1f29b6ac3614d3a5f61774" => :el_capitan
    sha256 "d10617714d882cce0a4a8754c03fe7f9df7adf01de8b0016cceafe092e98c163" => :yosemite
    sha256 "92ef32e3fff775db370d3c83ee1b09c0d3c7debab448be37f30465094b17f028" => :mavericks
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
