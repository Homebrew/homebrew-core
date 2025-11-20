class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "a3d508507022919429308d9c2d9cace99ff2be56"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.36.0"
    sha256 "26e6ed2233d88172b30728c21f84a2019c01617bb25c6235f852003835416d99"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "3a1096be515b962162bbce9ea6b827392b05f46eab5fcbf76fbb168312e80010"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "d2f5dc10c4a31178180fe8b23b89beedaab104d2c43cde648e3bb14059df57a1"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "8d382f3cba00193eb32d7ef90e8b57003ca4fa9d254864253682c90cf0e53ad0"
    end
  end

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef35a96f86a562d2e4ce13a0bc898e5ae48512877091f31a1dc54b3c3da3d9e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fdf6d88e97169dbd88d75a957b29e8cddcc943b0f414fe67317dec60cdcbb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "353120aefe38373b6018daf45a1d9b66fd0ac1ccbc24f25c68837dcaf255e8d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f02fff09b38ba190b4eb51ea41e7a9cffe8251d1891d6fa4fe2a11cfcdab356"
    sha256 cellar: :any_skip_relocation, sonoma:        "de49fdc83e656b413608cfb40bc59425df4a3538d3e53162cb2b8a55466f219e"
    sha256 cellar: :any_skip_relocation, ventura:       "ba081200e60b48da1e935fb572fd28c7583cd070806b86fbb409ac5a9fb704f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caea91cd4156e7b148c5328f5a0590cfc0fac5819a8baca8a80938cab96f28a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9e1b98be14b7ab9af9a7c1ee458ddc55045f11666e5fe8edcf7c59156fd1d3"
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
