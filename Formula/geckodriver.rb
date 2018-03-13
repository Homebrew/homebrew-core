class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.20.0.tar.gz"
  sha256 "0bfd25ca4ee396fbb1d9685decb9c68890b9e8997d1e7c35f1da40f7a232aaf2"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    rebuild 1
    sha256 "579bc00a6c39dac983705426453104099af036f6f0651e50a49cb25e4a52a60c" => :high_sierra
    sha256 "c7523715a1f1610051bafd47861976da1ccbc4a2203e0df263c52426d3bebe00" => :sierra
    sha256 "9688a792640220274fdf61b87cc4bb1135c2a4d35c2f627b6bd859f5674152ac" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "build" }
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
