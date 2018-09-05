class Mpgtx < Formula
  desc "Toolbox to manipulate MPEG files"
  homepage "https://mpgtx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mpgtx/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz"
  sha256 "8815e73e98b862f12ba1ef5eaaf49407cf211c1f668c5ee325bf04af27f8e377"

  bottle do
    cellar :any_skip_relocation
    sha256 "40240b442f8d3c41f89a38da8055cbf30fc10a4ea8b4dd469903d19c424851ce" => :mojave
    sha256 "6a003e12c03f1cc24bd520e1cf153da02729b4d30e7bdffcba5cecf832c19238" => :high_sierra
    sha256 "70e1dfed0338fb8b8cda36ca05e05b8cd3fd456782db58408b18bbf2361f09aa" => :sierra
    sha256 "566ce06d938b4e3b7886a729d456bd3034325985acbdb5e21355b076d7acccf5" => :el_capitan
    sha256 "dbe21236b1f2ae76dca4be4fa259c9dd902d2b109a6f0f0549cc7f6463945d06" => :yosemite
    sha256 "a9b32ab7e68133b508d9f919a740ed279567e1b68d3d9a72e0a50013a1029b11" => :mavericks
  end

  def install
    system "./configure", "--parachute",
                          "--prefix=#{prefix}",
                          "--manprefix=#{man}"
    # Unset LFLAGS, "-s" causes the linker to crash
    system "make", "LFLAGS="
    # Overide BSD incompatible cp flags set in makefile
    system "make", "install", "cpflags=RP"
  end

  test do
    system "#{bin}/mpgtx", "--version"
  end
end
