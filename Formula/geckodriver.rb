class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  stable do
    # Get the hg_revision for stable releases from https://github.com/mozilla/geckodriver/releases
    hg_revision = "e9783a644016aa9b317887076618425586730d73"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.26.0"
    sha256 "c5854000621938de2aac0bdc853da62539e694adcba98b61851adcbb9ce54dd3"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "d84d6b84d4b37bb4fadda639026eca63dc61dd289bbeb3961eef1257be49266b"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "a838ae82753aaed38eff52bd2076e47a418858be39c7dc5d833070c6ee2f7beb"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "107aaf145d4840a389c2d4586660e95e3fa336a42bb9f94524f9a72c89c21d09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b9a2eb29b8199df3f0c8e3a4395337fcdd1ae00cea28970df0add10a36b94ce" => :catalina
    sha256 "13dd973454d187da00ccd4ab24f72987ea47f4984caa2e1fa5b3c36273d96bfa" => :mojave
    sha256 "2e57ba33554f7b0180873d49dc8dc1b1587e9c8d637d8f50146395dcb923afea" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "unzip"

  def install
    unless build.head?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging"/"testing"/r, buildpath/"testing"
        rm_rf buildpath/"staging"/"testing"
      end
      rm_rf buildpath/"staging"
      (buildpath/"testing"/"geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
