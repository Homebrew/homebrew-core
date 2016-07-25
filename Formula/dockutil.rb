class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.4.tar.gz"
  sha256 "630adf817dffb1eeb6484e7d5d997ea1018dd57e2729773dcb90a0958ed46a24"

  bottle :unneeded

  def install
    bin.install "scripts/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
