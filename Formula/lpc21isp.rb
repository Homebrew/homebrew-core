class Lpc21isp < Formula
  desc "In-circuit programming (ISP) tool for several NXP microcontrollers"
  homepage "http://lpc21isp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.97/lpc21isp_197.tar.gz"
  sha256 "9f7d80382e4b70bfa4200233466f29f73a36fea7dc604e32f05b9aa69ef591dc"
  version "1.97"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c3756fd99268814cfdc861e971d1201bac42bf5b922ab37119fcb082c86a1c" => :sierra
    sha256 "c12b33d514be2490a3a5bb9d3c1f8468e7e24d13eee0a636a9d067f486af59fc" => :el_capitan
    sha256 "10deab3f8de3cb88b27ea38344ba7c641b758faf45f9a247f3fca968f6db456b" => :yosemite
    sha256 "5631ccbccd2bb128a1592399a558cbb837d63eb9b1ac2d8187c34fb42064b226" => :mavericks
  end

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
