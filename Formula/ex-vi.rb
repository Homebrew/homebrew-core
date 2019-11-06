class ExVi < Formula
  desc "UTF8-friendly version of tradition vi"
  homepage "https://ex-vi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ex-vi/ex-vi/050325/ex-050325.tar.bz2"
  sha256 "da4be7cf67e94572463b19e56850aa36dc4e39eb0d933d3688fe8574bb632409"

  bottle do
    sha256 "843fceed3514fe1506e32619c15c092441d45d553a809b315f38e1b749623492" => :catalina
    sha256 "112fa443488e178fd67fe600de3e56ad40179e8aeb73314c1286cea827df3220" => :mojave
    sha256 "63c5da327ae066a381dab232102b82621379c70c700949b5dc31d87b3dd56f75" => :high_sierra
    sha256 "2719bdb0715bd327745b0b4c6829492115336314a921d0b66f2f1a2609c949b0" => :sierra
    sha256 "e3f68edff7a526463ae6a217b9292c2a6025489df848372abe777da141be14ef" => :el_capitan
    sha256 "6e3195cd61b05a482e13162a5559ca90d65b1805b8559c006ffc960b56cbe935" => :yosemite
    sha256 "e0ff9cadf9bc20d222ebc0fceada33db977a5b044346e7930e8349a46e8e6915" => :mavericks
  end

  conflicts_with "vim",
    :because => "ex-vi and vim both install bin/ex and bin/view"

  def install
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end
