class Proctools < Formula
  desc "OpenBSD and Darwin versions of pgrep, pkill, and pfind"
  homepage "https://proctools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/proctools/proctools/0.4pre1/proctools-0.4pre1.tar.gz"
  sha256 "4553b9c6eda959b12913bc39b6e048a8a66dad18f888f983697fece155ec5538"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0fe70530d22c270ac3d5a105f2dbbbb0dc6a664acd03f3ad7da3f86255fd548" => :catalina
    sha256 "f7466405a3aab3cd7b00669ea685b1fe463a19bbdd7fef8b8c25f86595de2d34" => :mojave
    sha256 "d41f76776e37f54cabf5d76ce2cb89d13052f1221a70b325245f600a7bd047ae" => :high_sierra
    sha256 "8567dd0ffde620f8b1dd18e0529d670a235bcde6dac7b3f19d6528ecf843613a" => :sierra
    sha256 "ed8136da9f7b607eec69d014b1c3f81b9ef3f004f38cc2904400861c0d6adab0" => :el_capitan
    sha256 "a05e2adbc0ff0e11be133a81748fc123adc8b32002ff5efb49d141a354f92d70" => :yosemite
    sha256 "812961a8a321441010a786c4de1b97c830181a013dae457b6b44c96ce799eb22" => :mavericks
  end

  depends_on "bsdmake" => :build

  # Patches via MacPorts
  {
    "pfind-Makefile"        => "d3ee204bbc708ee650b7310f58e45681c5ca0b3c3c5aa82fa4b402f7f5868b11",
    "pfind-pfind.c"         => "88f1bc60e3cf269ad012799dc6ddce27c2470eeafb7745bc5d14b78a2bdfbe96",
    "pgrep-Makefile"        => "f7f2bc21cab6ef02a89ee9e9f975d6a533d012b23720c3c22e66b746beb493fb",
    "pkill-Makefile"        => "bac12837958bc214234d47abe204ee6ad0da2d69440cf38b1e39ab986cc39d29",
    "proctools-fmt.c"       => "1a95516de3b6573a96f4ec4be933137e152631ad495f1364c1dd5ce3a9c79bc8",
    "proctools-proctools.c" => "1d08e570cc32ff08f8073308da187e918a89a783837b1ea20735ea25ae18bfdb",
    "proctools-proctools.h" => "7c2ee6ac3dc7b26fb6738496fbabb1d1d065302a39207ae3fbacb1bc3a64371a",
  }.each do |name, sha|
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f411d167/proctools/patch-#{name}.diff"
      sha256 sha
    end
  end

  def install
    system "bsdmake", "PREFIX=#{prefix}"

    ["pgrep/pgrep", "pkill/pkill", "pfind/pfind"].each do |prog|
      bin.install prog
      man1.install prog + ".1"
    end
  end
end
