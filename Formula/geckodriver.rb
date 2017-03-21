class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.15.0.tar.gz"
  sha256 "45dc5ad9eee22bb0b37f0b7684ef96b09d14665110b76f2165286fb55741be4f"

  bottle do
    sha256 "5e3432a2acd35efd2bcaf24978d2a27d996c75153cb4fe36bb9d6f35680d2c77" => :sierra
    sha256 "a44f3b4aa10e993b158af243bbddac7b0c9149800967ac4687106caf96f8f6d6" => :el_capitan
    sha256 "3f8f4b6548ae6df32243426e795d3bc6b23e90059c7e02047e9e470c70023821" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
