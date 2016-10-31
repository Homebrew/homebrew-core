class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.32.0/esniper-2-32-0.tgz"
  version "2.32"
  sha256 "5ee3e5237c6a12059ae9d38380505d38448c2c12787f9fcc603cdb0a1a519312"

  bottle do
    cellar :any_skip_relocation
    sha256 "d00cc159457e65880455bec0e26cc9ce8c6b2a7204e7e3503497aab5ad455acf" => :sierra
    sha256 "d73b509b0e6350ec85ca5719c130b4c2aa0733a0c45748dd8dd616201babb53b" => :el_capitan
    sha256 "bb0bd9ade19fe5ce06e90012a524692aacffa9d15940f4ea2986f429549288e3" => :yosemite
    sha256 "fe731e40a8b00d5a5dda9628a16b9debc0b44653f822abbc2f18739e45e8147d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
