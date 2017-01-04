class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.12.0.tar.gz"
  sha256 "a893129f3cb8f6b95876e79cf50ae2af9c2df6d7e3d8654bdca8963729a0a468"

  bottle do
    cellar :any_skip_relocation
    sha256 "677fd03fdb1f590c8b5f7aee0efbb3e60583ed7a305f79daa43027b08eb40fc9" => :sierra
    sha256 "1ab8bbd78a432c84f7f0d2b57265f408825a8008f2f8b37e1efb861dbb4b84a7" => :el_capitan
    sha256 "b2704e574b55568661d4b7a2cd00ba2556ad64e6b4eb9713ab14b442bcec5a89" => :yosemite
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
