class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  version "0.9.7"
  url "https://github.com/getgauge/gauge/releases/download/v0.9.7/gauge-0.9.7-darwin.x86_64.zip"
  sha256 "dbb710e7042732a05f712b981750260c136c04994928596b7b3686a70a791ca5"

  bottle :unneeded

  def install
    bin.install Dir["*"]
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
