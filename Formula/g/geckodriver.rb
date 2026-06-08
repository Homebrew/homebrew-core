class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "253b8523586577438a3ddf86d67436719feaf6d8"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.37.0"
    sha256 "54e8cd0fa383d5d57e41fd33cc44031bc56e68f2ca0b1b710cf69d8335068214"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "05adf7e23832a37b11163d0b3c2571f6416cec07a779effaf86472a8a5885c06"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "6a51d3c7369d0bbe885377ead295893465a467df8080b0aed7fc51cc84612623"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "5036623e293ad9ec87af50e07ab6d1946da225be2709198c48bf6636cb2c1145"
    end
  end

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dfca2edf8a430c1123c63105cf0e3117ca50dd1ac8fe127c521de995f02c65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bead554258eff6b4d2524304cd35422cde072ac537d7dc4d8d5412c646767e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45fdb06f70e8e63df4568c22de843f46598eebaa3c4534fdc40bda8c24729bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de88177363533d56200918cb12f01dbdd355d19ce0358ce8790d961d58885fb"
    sha256 cellar: :any,                 arm64_linux:   "4074b185fa69f7105513c1eb3a33be3b3138b5e76558c0e318e65b5e23839fec"
    sha256 cellar: :any,                 x86_64_linux:  "fbe5f5a88f1a060ab4df8932bf2ff54861b212b501728d4de65f0725c0051047"
  end

  depends_on "rust" => :build

  uses_from_macos "unzip"

  def install
    if build.stable?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging/testing"/r, buildpath/"testing"
        rm_r(buildpath/"staging/testing")
      end
      rm_r(buildpath/"staging")
      (buildpath/"testing/geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    pid = spawn bin/"geckodriver", "--port", test_port.to_s
    sleep 2

    # A functional test requires Firefox so we just make sure HTTP GET has a response
    assert_equal "HTTP method not allowed", shell_output("curl -s http://localhost:#{test_port}/session")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
