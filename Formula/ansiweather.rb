class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.12.0.tar.gz"
  sha256 "5f331a8eb37307c198660cad9a4b19cada5fc13fe85dc99d9e9703c630cbd27d"
  head "https://github.com/fcambus/ansiweather.git"

  bottle :unneeded

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    assert_match "Wind", shell_output("#{bin}/ansiweather")
  end
end
