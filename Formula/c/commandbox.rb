class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.2/commandbox-bin-6.3.2.zip"
  sha256 "f1f271a15d4c2281c6adb145972d963d44f4624ab52fce44dad326f32f283e56"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d480d8d137307a6345253304e5f9f3a4d862350aefdeb89ca0ba990ea65e6759"
  end

  # Keep pinned to Java 21 until https://ortussolutions.atlassian.net/browse/COMMANDBOX-1685 is resolved
  depends_on "openjdk@21"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.2/commandbox-apidocs-6.3.2.zip"
    sha256 "9dbcb1c7dce3d5154a85f4e3e79c235ce16922c6c6b0f5e59ee366f2682ee27b"

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
