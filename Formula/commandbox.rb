class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.2/commandbox-bin-5.5.2.zip"
  sha256 "65a14ea9e12dba04d95438fda20a550d8bcbada769f418d48f39fa542a8f862a"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16a80454d87d885fd04543ccf315ac60526d694909a9bc235017f510bcd74008"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.2/commandbox-apidocs-5.5.2.zip"
    sha256 "91d4402c22a1bb18d4a01f2023871a1aeded0e30fd5b160ce18481a6f4d8a6a3"
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
