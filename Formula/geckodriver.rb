class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.21.0.tar.gz"
  sha256 "28848219addea9f56b1a75f9e1b3ae29edf74066bb47e5cd9e719b97be1a69e4"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "78333529ad9b34ca9b17e0bea3dee0a5193f65c472c448712bb6b51f6d611efa" => :high_sierra
    sha256 "44d70bc0cac39828c7da58c3c2b8c239368ca7b0cb938343cd5b56e49580c98a" => :sierra
    sha256 "e1e8201b171ef0122b21373abea31968ba5b74a69374c9bd208059389420c323" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "install", "--root", prefix }
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
