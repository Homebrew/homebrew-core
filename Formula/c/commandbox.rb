class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.1/commandbox-bin-6.3.1.zip"
  sha256 "df07ddd13d1eb819fb0c3f35ffaa89007b1934dcfe18051679fc8806861007bd"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c94a89fe731cc4b0fd21ce478bbd05166e912c8d6b14cbd42ec27b0620d03021"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.1/commandbox-apidocs-6.3.1.zip"
    sha256 "2abfd7d4acf2bb24df7b9ced669a94d6f1151fd027b0b7ca788e4ab8a0f83df7"

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
