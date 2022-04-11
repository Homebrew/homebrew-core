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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c82fe68878015aa573a126f052fdb64185514a73029f939de09b8914e45a6b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6034506dae2c3cfac3fb2d65c0d06f9d68722dfa954cecb6deb10bac87ac18b4"
    sha256 cellar: :any_skip_relocation, monterey:       "daf096707d1fb04b0b3c07b487afeaba45ba542a4ef9bd5b123efb741da8215a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd96ba611f8d1ba97df0a21d910a6368e683d0a6bd1a05073e5afd27e6aeaf3b"
    sha256 cellar: :any_skip_relocation, catalina:       "d490f9171f301363ee590ea705d1f111c8c90aa68bbfb70e8dcf093b6dbde424"
    sha256 cellar: :any_skip_relocation, mojave:         "c76da857f5accdf0756374fb3688e82567da285c2f4f40eb78fbe45e4756b5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25146e5cf935a7a6405e0406dbf443c4198a3ce6de2104fba8f56e9bf70955b2"
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
