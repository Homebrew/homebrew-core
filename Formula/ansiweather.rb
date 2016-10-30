class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.09.tar.gz"
  sha256 "75f705263c8ca1eea74039c478b6c760632f26e3b503ac9d04cd1ab188d1ca77"
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
