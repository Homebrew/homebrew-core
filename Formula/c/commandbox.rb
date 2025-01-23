class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.1.0/commandbox-bin-6.1.0.zip"
  sha256 "2bbf025ced8ae99fd7edb8f09c8a66ed0df095e45d2474f69e7d7e07fb55066b"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51c08acddaea8be081a9c56e66aed42f0055a68e2ceaebae346afad2bae3bd1f"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.1.0/commandbox-apidocs-6.1.0.zip"
    sha256 "f4bf29732cc97cfd1ef6bd11af3bed0cb9423030b2365af9806eeb8ff83ffa00"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "apidocs resource needs to be updated" if version != resource("apidocs").version

    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env
    doc.install resource("apidocs")
  end

  test do
    system bin/"box", "--commandbox_home=~/", "version"
    system bin/"box", "--commandbox_home=~/", "help"
  end
end
