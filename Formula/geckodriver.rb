class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "4563dd583110be33b4767284f04e1ea83f1a78bc"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.32.0"
    sha256 "826555d976fef919760ee876b8169409cf3fda18181e6107ea86fd7bad5fa284"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "31bddb7e01f8c0cdb1a0762b0a6880428e49c5c2508a37bee161898a26721aff"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "4140a82d895b5f32431dbbd353e2a26e760386e110f3c5bfbc382752fcac09d8"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "48dd02b59cfa2d8001b90eec794f75f1d48dafc1d3e01948d027ec7dfe3b57d7"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab664ec65129e83349b8a1e67d8f2866c6c506798f945db3fa5bd0454d6d38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6328e98b46b2db7edb0072cfb4d92ad087448a4ec6f156d8f79a11924ad60ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9cd53898c0d8a9d2af994ef00106d6153417d1850ed3f8a83e7b3ae5bfb23a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e3bbe5782cb999b5c670cf5c8c57ea2a875d046c74d7a529df18d41b3764df9"
    sha256 cellar: :any_skip_relocation, monterey:       "89f9106564069fe3c04d727e3af29925f20aaa11ea126dbc9a85709775339093"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee69da484abc011d6c72ba2800418d6bec02e10d0d972ac8ce6477e224278703"
    sha256 cellar: :any_skip_relocation, catalina:       "443343d77688b10b7567cd2d38ea58b6226f8ab86cb6f3ffd00760b21d8cd8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4c87dd70d9e048a5b0af6b4e1230454f644d3096b9166da9063bb5cea3c74c"
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
