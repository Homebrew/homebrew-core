class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.16.1.tar.gz"
  sha256 "7345696ada459312d28c9f2892f0cb3023cde352cf77482cc6c8912a2f02ac06"

  bottle do
    sha256 "e01a8ec26cdce60bf32a7035e6e640649bd152f95a44c9373ccfcd1323a60dbf" => :sierra
    sha256 "db88c44667614691a7bfdadea38566ed1c9dc8ca7e4b7eb19513ae562e3c250a" => :el_capitan
    sha256 "ed67debd508c915ef86e20fb1d21531a219d68a3c8bff33e755a7e8dd1007dc6" => :yosemite
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
