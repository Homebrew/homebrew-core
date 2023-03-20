class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "602aa16c20d47216f2e4a3b8877c3e34ca947f33"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.32.2"
    sha256 "7dd4c132ddf3f15c65a5b8b764afc6708ac5c9a4b19d3f9844cd59412bca6ed6"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "074dbee7f7d55e95b539eaf119aed2166852d2a2613fd8e6f52fd73fb547aa7e"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "24413a09a7df9545f4aacb36ec156531369935f5ca861bad5ed793029b00a005"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "1c1f5dfeef8e179585f45f7593f136e4e819c00dd5bc23fe30abdf2399aa6504"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dff2022f6e69e4605dd20aa5c3882de3d9d62a97dc07787cd13f95d23963efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77cecfc17b00de5d68bf2b2fe6e10482d9d3f2eb854c719186155b3d911b2b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47759c4e51b9776dddd0e375455f7edc136e609fe28afdec7ed5813c6666e0ff"
    sha256 cellar: :any_skip_relocation, ventura:        "5638e66f5ad64a2d5044ff509296f1bf921da243eaf8fb302b3dba35fb4194ad"
    sha256 cellar: :any_skip_relocation, monterey:       "5258001155c04d7b0f8728e70afaba1aa8116dffb1936c1dad45760ea1403790"
    sha256 cellar: :any_skip_relocation, big_sur:        "5620c3a61bc77139cb11b7fc2b15219cfdf4d89a16afd4920c11928d4514f397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc91b4658a9b42e4f8e2aa1de704ecbc7c5b118ef8b08f221c8ebd771c66d79c"
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
