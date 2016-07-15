class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.1.1/commandbox-bin-3.1.1.zip"
  sha256 "050bb737db3033a7ae8d47f2e5a973583963328c7ed1c3e1ab7b1191c609ac60"

  devel do
    url "https://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.2.0-snapshot/commandbox-bin-3.2.0-snapshot.zip"
    sha256 "f4ab2733629f0ff9b0ed2efc17e4a6f219718d5da1a7d6f1fae686f9d4f55945"
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "apidocs" do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.1.1/commandbox-apidocs-3.1.1.zip"
    sha256 "0495a4055582b4278de73a6edaa6526b7acf13daafcbe7bc65c67f97031edd93"
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
