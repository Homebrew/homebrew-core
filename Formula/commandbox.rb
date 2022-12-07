class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.7.0/commandbox-bin-5.7.0.zip"
  sha256 "a45c30d12dd4805c48610b9948e48ed167a5f35cd4c8ce4a5b450b0e07514baf"
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
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.7.0/commandbox-apidocs-5.7.0.zip"
    sha256 "960c8363992e7bebf8d48c20a6680d9877d345eb552b908b8406007cf2c4d9a0"
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
