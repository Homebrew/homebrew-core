class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.8.0.tar.gz"
  sha256 "a3b2cc5fd48622cdc811f952565ab235e5b64b5776e1f03c889a5c5c02367e1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bc1e3ee418801a0aaa3f3141a0275dcaf797de60c86d5028f0882f71d7439a2" => :el_capitan
    sha256 "2e6440da97312f714e0943015e688af15e71a82d2c9834a6db349bc545527d7e" => :yosemite
    sha256 "07b7176c651e9fd17d7368234de4b8b9cd82bf9a02439848bc3528639c2ac112" => :mavericks
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system "#{bin}/geckodriver", "--help"
  end
end
