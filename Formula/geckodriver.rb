class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.20.0.tar.gz"
  sha256 "0bfd25ca4ee396fbb1d9685decb9c68890b9e8997d1e7c35f1da40f7a232aaf2"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "3167ec1406f1af96d6529a3dc91bfde96172ab0e81572bcfccaf69dde1a58c9f" => :high_sierra
    sha256 "7425f0cbc1f491e783fe06f17e85ae5bce6f5284d38fc71c1187667cf3617ef9" => :sierra
    sha256 "bcd8440509b93ca9788a6c25f8e5a2f118582e37e91af8936275d657ecd75eb8" => :el_capitan
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
