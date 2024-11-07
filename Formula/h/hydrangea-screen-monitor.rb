class HydrangeaScreenMonitor < Formula
  desc "For safely monitoring screens"
  homepage "https://github.com/Zeyu-Xie/Hydrangea-Screen-Monitor"
  url "https://github.com/Zeyu-Xie/Hydrangea-Screen-Monitor/archive/refs/tags/1.0.0.tar.gz"
  sha256 "4922c0a255f252bf7cc4309f7d49276a2bc629f5679335194aec9fe4a0301d4c"
  license "MIT"

  def install
    bin.install "hydrangea-screen-monitor"
  end

  test do
    assert_match "hydrangea-screen-monitor v1.0.0", shell_output("#{bin}/hydrangea-screen-monitor -v")
  end
end
