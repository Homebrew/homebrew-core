class Hab < Formula
  desc "Automation that Travels with your App"
  homepage "https://www.habitat.sh"
  url "https://api.bintray.com/content/habitat/stable/darwin/x86_64/hab-0.6.0-20160613151520-x86_64-darwin.zip?bt_package=hab-x86_64-darwin"
  sha256 "2251891c376bd3786a2c8242006367a3fd9f896cab850472c73886c6556598d1"

  def install
    bin.install "hab"
  end

  test do
    system "#{bin}/hab", "--version"
  end
end
