class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "http://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"

  bottle do
    cellar :any
    sha256 "4e4908340da96c5102325136a85a6dc9219f867fc34c5294c9e7f4647b0f7c55" => :yosemite
    sha256 "a9c25b6429f5635a9c805df9498f404bf2c878ced2f29c7f3bdc909c8c708d19" => :mavericks
    sha256 "d3734d89346e3c35de2fb2097ec6cc5ac4938f259c0b9e18c52e2b0e6c5abf34" => :mountain_lion
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/advdiff", "-V"
    system "#{bin}/advscan", "-V"
  end
end
