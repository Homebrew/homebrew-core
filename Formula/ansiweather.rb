class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.18.0.tar.gz"
  sha256 "362393918b64083de466414ca3ada3e0236206b29bfb2624d4ad1284774e6a7a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fcambus/ansiweather.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80cab6cc26ed03f58ec06f593fda3dd072cbf0a8255b9f6afbcd02f516d9cd7f"
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
