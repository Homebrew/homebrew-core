class Gpcslots2 < Formula
  desc "Casino text-console game"
  homepage "https://sourceforge.net/projects/gpcslots2/"
  url "https://downloads.sourceforge.net/project/gpcslots2/gpcslots2_0-4-5b"
  version "0.4.5b"
  sha256 "4daf5b6e5a23fe6cd121fe1250f10ad9f3b936bd536d475ec585f57998736f55"

  bottle :unneeded

  def install
    bin.install "gpcslots2_0-4-5b" => "gpcslots2"
  end

  test do
    system "#{bin}/gpcslots2", "-h"
  end
end
