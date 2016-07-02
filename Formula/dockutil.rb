class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.3.tar.gz"
  sha256 "6954330cc2b5280bbb345c208f9cb1c51a50c2b04a7ab5d278e987167ec01a4b"

  bottle :unneeded

  def install
    bin.install "scripts/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
