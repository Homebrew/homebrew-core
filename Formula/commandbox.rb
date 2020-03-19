class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.0.1/commandbox-bin-5.0.1.zip"
  sha256 "9f855c5b796ac36b010d8b64d58664650d381446d52e0e9167249d4df0269215"

  bottle :unneeded

  depends_on :java => "1.8+"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.0.1/commandbox-apidocs-5.0.1.zip"
    sha256 "0ea965ae60d8b277a19beccb960324cde3d3068dcd16c17146f786bdf57e035b"
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
