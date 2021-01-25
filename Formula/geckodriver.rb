class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    hg_revision = "cf6956a5ec8e21896736f96237b1476c9d0aaf45"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.29.0"
    sha256 "26b86be8c1fe47d1a7b25ae6dfc280776567c9d48b6c7491eb0e7fcc1944a8d2"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "d8579cd155aad688931361b3ca8f1e8260592641162d5e51a78b59e189e44c56"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "d3693c78c0186b34197b1fdfd34a2694a155dc36ce0a50d5ccfc558aca54fd0b"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "048970448a118b1569b9e70192c0214a86363e0c25094819d4cf6b99ee54eef0"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5e3b3b2ea70199fbfb3dc656eab997e2d99cc298579fdf03097f11ab4d046161" => :big_sur
    sha256 "22254633b2eb8926074a54c4304df503d44e52ba91192aa248143df17c91fd30" => :arm64_big_sur
    sha256 "2831a5194598fa63d7c5db952c14e9a95371db0ebf0fb93c88e992181c64e36a" => :catalina
    sha256 "c8b8c5e4de9f8e6746b1e6a565bea4438274d021fee94d0976f8ad46092e1955" => :mojave
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
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    fork do
      exec "#{bin}/geckodriver --port #{test_port}"
    end
    sleep 2

    system "nc", "-z", "localhost", test_port
  end
end
