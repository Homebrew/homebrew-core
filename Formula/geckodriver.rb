class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  # Get the commit id for stable releases from https://github.com/mozilla/geckodriver/releases
  url "https://hg.mozilla.org/mozilla-central/archive/e9783a644016aa9b317887076618425586730d73.tar.gz"
  version "0.26.0"
  sha256 "034f525b6163ffd473ac61191107d104244b5ac7d3f89259b9c2915812654099"
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
    cd "testing/geckodriver" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
