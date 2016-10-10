class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.3.0/commandbox-bin-3.3.0.zip"
  sha256 "72091365a6babbf0410db22affb1c03879195b8a18f8af4bf97e988fe68b9c02"
  version "3.3.0"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "apidocs" do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.3.0/commandbox-apidocs-3.3.0.zip"
    sha256 "17c073bc2741503d7105366a81675bf9a77b56697cc75387fdd6bd76545f0b9c"
  end

  def install
    bin.install "box"
    doc.install resource("apidocs")
  end

  test do
    system "box", "--commandbox_home=~/", "version"
    system "box", "--commandbox_home=~/", "help"
  end
end
