class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  # Get the commit id for stable releases from https://github.com/mozilla/geckodriver/releases
  url "https://hg.mozilla.org/mozilla-central/archive/e9783a644016aa9b317887076618425586730d73.zip/testing/"
  version "0.26.0"
  sha256 "89f20b2d492b44b40ee049d0f0d4d91c52758b74dd7b5c7acad89a88ca1f177e"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "e22f2630bb243d2ff0129f1e1807a21d7564563b198f5dcb0f15f9cc2d352c21" => :catalina
    sha256 "dc64495740d253d396aa2be1442dbcab5ad82b95b37f28c65eb724394e302ea7" => :mojave
    sha256 "aa4813eced6f47bf448a0f19ff1f73abc109122613a92aef6b217237020eba01" => :high_sierra
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
