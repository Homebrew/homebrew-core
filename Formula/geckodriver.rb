class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.18.0.tar.gz"
  sha256 "a2a5bbf6077c1dca05ef1ff1d48572803d022f2faf92a749721aa04c446d97e2"

  bottle do
    sha256 "3640b6e9b03a04d74194bb5139c26a7fdb9d19a56176424808d3f86529fe1e30" => :sierra
    sha256 "384550ff499cfe1ef1dc9a11081148decf5701b4e794f91bf9eb135e409b5cb6" => :el_capitan
    sha256 "2cc6ba0a43f21b1dc7a202709c3ede8080c79fd119a19f6417ddc9364901b8be" => :yosemite
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
