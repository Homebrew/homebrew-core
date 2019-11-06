class NicovideoDl < Formula
  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c43b33d48c8a63229f5be23d2397bac63d3651f98e1937a19a5d8c910083a6c" => :catalina
    sha256 "21a964141ae24de2635828bde4ac6f46ed09a8b03b5564050e36ab3df0b9bceb" => :mojave
    sha256 "21a964141ae24de2635828bde4ac6f46ed09a8b03b5564050e36ab3df0b9bceb" => :high_sierra
    sha256 "ff5c5d5a91e5384c20cd068a1857c83322e2ab27ac6ee0baf01cfabad44b9dd9" => :sierra
  end

  depends_on "python"

  def install
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
