class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.4/commandbox-bin-6.3.4.zip"
  sha256 "266c21ca3d0ab46a8cbfcdbe4ffdb4f059fe439768f8fb5397e3a931a4623b4b"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "415dfde649621b838d9d9cd5c5bbfd3b7056a2eb7afcd03381d1505244df5299"
  end

  # Keep pinned to Java 21 until https://ortussolutions.atlassian.net/browse/COMMANDBOX-1685 is resolved
  depends_on "openjdk@21"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.4/commandbox-apidocs-6.3.4.zip"
    sha256 "8be5b3181ecd66bc94a2a60936e00ca6d4011727b98234361aefd7add75c890c"

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
