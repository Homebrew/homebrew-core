class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https://github.com/kcrawford/dockutil"
  url "https://github.com/kcrawford/dockutil/archive/2.0.5.tar.gz"
  sha256 "6dbbc1467caaab977bf4c9f2d106ceadfedd954b6a4848c54c925aff81159a65"
  license "Apache-2.0"

  bottle :unneeded

  def install
    bin.install "scripts/dockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockutil --version")
  end
end
