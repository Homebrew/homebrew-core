class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "d372710b98a6ce5d1b2a9dffd53a879091c5c148"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.30.0"
    sha256 "fb28df48db18f5e559a5298f80f70acbfdf7db1e44b04d39ba8f8b676f125440"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "eb0d555e33e26e13fe285b87579d66ea054cb57c7355c36fe15917ab310faef6"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "45354a67258db8394b14f77a534ae09e52dab26dbb1f5bb6b24f6c251f5bf5f0"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "5daceea2850bd034ffb1b538b4aa5f8f6915f36631ef6dbeeb9d30fe26180c38"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "170d84b545509d7ef6759b84b59d209e6374c5cdb6a414113e783e61e0f591e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "136b5d41ebac01aa5baf8c355eaf4ee4ce3d3f08c1fc0758d438442daf520636"
    sha256 cellar: :any_skip_relocation, catalina:      "a09021c739b414fb0ac165cf76ab22b9033be3ed52e1d83c5d3096640b91b554"
    sha256 cellar: :any_skip_relocation, mojave:        "8be96031b68db4170630416c4c8c10578f0bac179d7b768962bd5bb77dd60d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fa50edf1a3f83d1928d379a13025f7a317005854df10f7d09492117794155d"
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
