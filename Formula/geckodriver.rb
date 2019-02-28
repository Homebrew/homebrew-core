class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.24.0.tar.gz"
  sha256 "e6f86b3b6411f078c0a762f978c00ee99926463036a68be01d111bd91f25340e"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "15d57a2252a5e6c6aa43d77862ef1bc052854bbe2d22ce2a20675e97b803596c" => :mojave
    sha256 "1d146bd0da0d5489f1032c35c6dd92b5a4f8dee20ab2881fe8c74ab266c62b10" => :high_sierra
    sha256 "e6802e185deefb48c408acc7ceef12420e2b7648851e07d0dbd4220184fb40a0" => :sierra
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "install", "--root", prefix, "--path", "." }
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
