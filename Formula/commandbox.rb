class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.1/commandbox-bin-5.5.1.zip"
  sha256 "806b255f39d5a428a3a905d6d81c2dd61f1c9ba79949396e953745fdb1892a1e"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4999591a13bdb126d0dc4aa8cc6d6c1808477a28e9e36a402c00df7a60e9980"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.1/commandbox-apidocs-5.5.1.zip"
    sha256 "eadefdf7986127a3b64d76830f458dd1fa784dfb8e782d11f40fcdc979eaccbf"
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
