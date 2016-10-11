class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.10.0.tar.gz"
  sha256 "bdbdd9e01831d48afeb324cf5c8f02aadad5bd30e4308e3fb34a07b596c547f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0219242056eac613772f1ad44c255bec61fe6a6c9bc88b05ba725c72787efec" => :sierra
    sha256 "fccfa382aa88aed9ad57afc4cd80a66a89217842dcd7f5f4274b4fc41719f15a" => :el_capitan
    sha256 "a4f6d2e76307ee1dced483223b0a3d8242aa5877ae8f9f828f6dbf474749de5e" => :yosemite
    sha256 "cdfacfa93eb1a418b2fa58e575294658b7384eb148e638c2b9a0bb4c172855cd" => :mavericks
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
