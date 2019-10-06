class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.25.0.tar.gz"
  sha256 "9ba9b1be1a2e47ddd11216ce863903853975a4805e72b9ed5da8bcbcaebbcea9"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "8d6981dce34a5554f170fafe37f83bc6793b8b9615022288310371b6e68de37e" => :catalina
    sha256 "beddf7cc7ac7f7c649823cef79a3e2531cfdeb35c5257e776d6a069548d29101" => :mojave
    sha256 "2d5600b848944ff98938b8ccadc1848e5e447e4df4404c33ad82c30318b5db24" => :high_sierra
    sha256 "396bb7d74bfccae7c18214c31f2f6de071c10b8deed08b3ea12b60869427dafc" => :sierra
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
