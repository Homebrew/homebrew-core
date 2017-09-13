class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.11.tar.gz"
  sha256 "14e3e55022925b7f54c7f15507c5e6612eb7826f3d1b19b7d3cc9cde68501463"
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
