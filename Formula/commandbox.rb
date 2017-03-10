class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/3.6.0/commandbox-bin-3.6.0.zip"
  sha256 "85c4336b50385eaf0194f1ff55bd79659f36a516ab0f2434c054a474b48ee7bb"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/3.6.0/commandbox-apidocs-3.6.0.zip"
    sha256 "bfb52645ed4302c65c53c589793511c36102f6a43131796bb82596552f03d2a1"
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
