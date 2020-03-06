class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.0.0/commandbox-bin-5.0.0.zip"
  sha256 "1f8a355c8851f35944f58c96a18ca5eb9d9f14364ebb61c1269149cefa1efa0b"

  bottle :unneeded

  depends_on :java => "1.8+"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.0.0/commandbox-apidocs-5.0.0.zip"
    sha256 "dc8acbc6b6ff1b7b14cbee085327d914adeb862a26560bfb76c6d88563b27ee3"
  end

  def install
    bin.install "box"
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
