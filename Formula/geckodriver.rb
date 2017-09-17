class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.19.0.tar.gz"
  sha256 "eba534fd299f7f3867523b059d414d88aa4e785d8962436f5b944d01638d759f"

  bottle do
    sha256 "e858b52610e48d9866ffb7966f2c5195e59b45fbcd9580883e8f268d824b743c" => :sierra
    sha256 "55ff6d54773aebcfe603903eb56673eb16af2113f12091d1c7583c5992c7817f" => :el_capitan
    sha256 "31b679ff1d0fd1d7097def82b4cb8ae232aee49da8e929b2129e582323511a65" => :yosemite
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
