class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.22.0.tar.gz"
  sha256 "60a4bafad93ab03bf44e7f0c1e726fad715742eb9bbdd32fae33c78fe452dc65"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "e041d1b1ff915d261ab6af82663cda87c456bde9290a46722d5dd7f5e3c4971d" => :mojave
    sha256 "9a4373bd72ac4f629e2b7c10c7fe871c22709d6081cd8d0d8efc2de6ac7c2cb0" => :high_sierra
    sha256 "7061cfa56bbec8f56edf259f64eae25ec14412d19947c8b68b4cbebc21b1139c" => :sierra
    sha256 "73e74c4cbcae001c4f015e6d0ce2b7a2a4cc8346cfebdd3331dc94fb258def40" => :el_capitan
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
