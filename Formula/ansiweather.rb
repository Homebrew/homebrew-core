class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.08.tar.gz"
  sha256 "22dd814ef158df13b3fdbe72ca39e820874e710a4d341d1a2367aa771609665d"
  head "https://github.com/fcambus/ansiweather.git"

  bottle :unneeded

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    system bin/"ansiweather", "-h"
  end
end
