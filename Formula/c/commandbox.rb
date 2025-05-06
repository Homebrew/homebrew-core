class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.2.1/commandbox-bin-6.2.1.zip"
  sha256 "c8f4c9befda31046fd535542024b21ae121ce12fa517f6c1405f88b432ce1f1a"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89fa62b33dfb9f7f9e0ff49252d252cf366d496ae3191d9fda916b4a6c999ef4"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.2.1/commandbox-apidocs-6.2.1.zip"
    sha256 "ff1c3eed5fd1036de851b57a6be25041844ca00516b7aa4ce6d1365eb8be47d5"

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
