class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "b617178ef491db37699e1442e4eb48b79a6bdb3a"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.31.0"
    sha256 "43ff15769ae64785e773827b5e4bf9432eaa0cb8838df88f983fd02e15167aa4"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "ae4b76a5cb2418f61c9ae89b04897d21d63853341dba4229c71bf0a8de43b43c"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "fca388c2d6ee2471c2fe4d3ee5d6163b32fb2684df3e77ee691fe12c429a6e4f"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "ac53dbf05ccecdbdcd98e8c521ae2d771d1918848d48780ac33b663993b25b38"
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
