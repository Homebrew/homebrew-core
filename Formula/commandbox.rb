class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/4.8.0/commandbox-bin-4.8.0.zip"
  sha256 "43ddb16d221b5e9e7165349195c3b1c3714b28710ba21d88d4cb6ad650213861"

  bottle :unneeded

  depends_on :java => "1.8"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/4.8.0/commandbox-apidocs-4.8.0.zip"
    sha256 "b9e2c734adfd59f122932271ccc9956b288f7d2a496853c370f61033868b7203"
  end

  def install
    libexec.install "box"
    (bin/"box").write_env_script libexec/"box", Language::Java.java_home_env("1.8")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
