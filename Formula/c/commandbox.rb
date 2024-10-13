class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.0.0/commandbox-bin-6.0.0.zip"
  sha256 "38746956adc14e9196eb9670e599c482dabd2f82e40a6256bc8e26a4435a488b"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fae0635162a96e2463c50058a2020f540821a563a3bd5d3d0ec881dff8e29ad0"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.0.0/commandbox-apidocs-6.0.0.zip"
    sha256 "48b62497772cd61dcfa57f603111853e44defeedb70c632f19b19af1e6f3bd91"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env
    doc.install resource("apidocs")
  end

  test do
    system bin/"box", "--commandbox_home=~/", "version"
    system bin/"box", "--commandbox_home=~/", "help"
  end
end
