class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.5/commandbox-bin-6.3.5.zip"
  sha256 "f8f5d31843724108f034a68d404d77a934d281108e1e21d510ae5b5a5db796f8"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e9887816ff47ff9d898668e62f64f8b9fc2f30ac221f742f5320b6a9b62eb24"
  end

  # Keep pinned to Java 21 until https://ortussolutions.atlassian.net/browse/COMMANDBOX-1685 is resolved
  depends_on "openjdk@21"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.5/commandbox-apidocs-6.3.5.zip"
    sha256 "c3d45afc0e711b65b3b2c7d2b2a48d5a69d5e930fbab06491927c0c5968ef37f"

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
