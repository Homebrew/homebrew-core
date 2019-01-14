class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/4.5.0/commandbox-bin-4.5.0.zip"
  sha256 "26eb515fc41138f0d7b2503d6242c57fa4db9f6cfb6a5d0783a9974ec203813d"

  bottle :unneeded

  depends_on :java => "1.8"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/4.5.0/commandbox-apidocs-4.5.0.zip"
    sha256 "58632f302ccda65c1260fc2081eeacb7823e1b34d780c77697fc34dcca61d5ba"
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
