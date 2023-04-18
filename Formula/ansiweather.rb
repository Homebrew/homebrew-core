class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.19.0.tar.gz"
  sha256 "5c902d4604d18d737c6a5d97d2d4a560717d72c8e9e853b384543c008dc46f4d"
  license "BSD-2-Clause"
  head "https://github.com/fcambus/ansiweather.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c1bc49161f466ba2c18219918f324c2aa22e63b0e1078e275d1832f1c349e2f"
  end

  depends_on "jq"

  uses_from_macos "bc"

  def install
    bin.install "ansiweather"
    man1.install "ansiweather.1"
  end

  test do
    assert_match "Wind", shell_output("#{bin}/ansiweather")
  end
end
