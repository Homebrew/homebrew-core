class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.4.1/commandbox-bin-5.4.1.zip"
  sha256 "7821675ba886db995f1624aa8d991b9b5e303bd7a998ea415d1aa5bee5d3eff3"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0752eaf911826ad76b544944897ab91a4ec32293d37baafe78905af08db80b4b"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.4.1/commandbox-apidocs-5.4.1.zip"
    sha256 "76f76acf8e81cd27fce14a790bf128d05ccb431bc2cc082e2c820fabd6d0a3e7"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
