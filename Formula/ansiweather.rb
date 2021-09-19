class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.18.0.tar.gz"
  sha256 "362393918b64083de466414ca3ada3e0236206b29bfb2624d4ad1284774e6a7a"
  license "BSD-2-Clause"
  head "https://github.com/fcambus/ansiweather.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "242abc21c45bf8e66ff74e62dcaea4fd62b3ddeddc8d280b35e405341f37689f"
  end

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    assert_match "Wind", shell_output("#{bin}/ansiweather")
  end
end
