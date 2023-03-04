class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.8.0/commandbox-bin-5.8.0.zip"
  sha256 "c790ae6de64992782dd80659c901c2b5b49cfeb50ed4100449a3fe083e1838ba"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a18aef55e8f1bda49d40d90d32996aeca8a67c3ab531a4031c751e5079508a1"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.8.0/commandbox-apidocs-5.8.0.zip"
    sha256 "fd52e249e0d1666b6c9e0705041e194084a5eae088714ec036d0c18a6d7fb977"
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
