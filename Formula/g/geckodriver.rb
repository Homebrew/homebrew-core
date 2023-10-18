class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "a80e5fd61076eda50fbf755f90bd30440ad12cc7"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.33.0"
    sha256 "0cc493ff77bb809e6925edd28baf6237b8e60950b7d3d2632847339bd1384b3e"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "70e571deb26b80ebf23984218ba253bcb329b10a02ce3e96ab84ba36214f52ea"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "55faf1bd9c8239cff541c6d7c92fb63c284543f90a6eb6ad934e506d4d3f115c"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "40b7cd177ae5f9a1f1d40232fca9c1d6d7538b8e0df535e851c0c4d93e07c659"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd78430189604f5c19a453a34ba41607c126d4de8c9973eafa16b2926c60e91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58e395855e57f06d764c3def6d6d097258e02635a71ab3966192738cc5eecffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf155d33ba2b30186ed870e1413e37b6074d28053439d9072170f109328fcb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f157c4a44d2015c691e83162c2f99616b806787059f89efa576b95cff83301"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc3ca9568521dca4942e298c3e6345a33be01c9fb01ade0b924c60d9db56e50"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8893249096660b0a31c030e402fd19971a41445e0a6b2435c27672c604d510"
    sha256 cellar: :any_skip_relocation, monterey:       "a38132365353a169d06c78d167aec5cd2d366e7300302f516aa3c1205eab1cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "520359529fe9f90c5fb182acf27421c39603bf7f43756ada27632e34c90538e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193f488a95a9ac7ec532f3284a619173208fc26da0fe2bd5140a5bdf418c6aff"
  end

  depends_on "rust" => :build

  uses_from_macos "netcat" => :test
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
