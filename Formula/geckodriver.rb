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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45b968c3ccc7baade1c0bec675617612e3473b3230eff731d508983d3e579a99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17826e1089087fca388447148cb3c81f8014906145d07aa0781664b6c1a9f3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "5db7bce413b92193965e3eaddcb60d1c813c9a1fe2ecdd6d7d096a6da46a11df"
    sha256 cellar: :any_skip_relocation, big_sur:        "bffc9a6ebb432acb2d5b364bcf1d5d7da570b4db26a4af542a0454c6a97430c3"
    sha256 cellar: :any_skip_relocation, catalina:       "0586fe4a365b7873e0d07d51cf5bacbce69d726510c85886b18e22f1ba8de6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "972dc045d16005c5c33c6a51fb7f5b6c34f531912a69afd2632a6a21de9ca18b"
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
