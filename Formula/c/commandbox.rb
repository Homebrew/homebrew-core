class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.3/commandbox-bin-6.3.3.zip"
  sha256 "7f4c49758939fc99c7ddc7ceffc322bcdb5d591605e7110097190bdd2bda5c84"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86219dcf026eec8d2dc256b8009c62743a4a7cff095e726e303178d2b54279a8"
  end

  # Keep pinned to Java 21 until https://ortussolutions.atlassian.net/browse/COMMANDBOX-1685 is resolved
  depends_on "openjdk@21"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.3/commandbox-apidocs-6.3.3.zip"
    sha256 "440c37353719fcf871b71b4daf0b90f52222494a7bfc31b722f55337c6f41560"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "apidocs resource needs to be updated" if version != resource("apidocs").version

    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("21")
    doc.install resource("apidocs")
  end

  test do
    system bin/"box", "--commandbox_home=~/", "version"
    system bin/"box", "--commandbox_home=~/", "help"
  end
end
