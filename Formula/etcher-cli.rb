class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/cli"
  url "https://github.com/resin-io/etcher/releases/download/v1.3.1/Etcher-cli-1.3.1-darwin-x64.tar.gz"
  version "1.3.1"
  sha256 "6e862e2d2e64c264fb90ec409d82b43c1719453f5ed1cff18aa31b2d890ac6c7"

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/etcher"]
  end

  test do
    system "#{bin}/etcher", "-v"
  end
end
