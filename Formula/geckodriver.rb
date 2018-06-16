class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.21.0.tar.gz"
  sha256 "28848219addea9f56b1a75f9e1b3ae29edf74066bb47e5cd9e719b97be1a69e4"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "619cbf30892108fcd05a423321392f27332918560a1498d71c37eab4e7294b72" => :high_sierra
    sha256 "e048038a056738d753e9937737753331e564306a5ea034079652c4dd40b27399" => :sierra
    sha256 "39f790fa76fe15069eaf4d49dccc28408344a5381c6bbb59fb655ef5213f5444" => :el_capitan
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
