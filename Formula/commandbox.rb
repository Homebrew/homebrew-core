class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.6.1/commandbox-bin-5.6.1.zip"
  sha256 "4a9ea32cf310b131b1c7982991bb1aac2cc841c01e2602a7eb2f02140a350d85"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4612f70f274f10e3a71dde032e0d625289b8c2e6d7868c7bf20cd7f8d2c85917"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.6.1/commandbox-apidocs-5.6.1.zip"
    sha256 "516086b4e03fdb8b39e90754f5f201dd9fa9f67c0810900803340ff7540f4f0c"
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
