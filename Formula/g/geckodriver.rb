class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "9f0a0036bea4d15e95ac10baa4a2328c8b0e4031"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.35.0"
    sha256 "e06f62f008cd455265f4a4789a5659b5049c96a0820b42c6db42e04a396f79cd"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "a3dbb655be02b5a2d8ba94ea73caae3e3fe686f5130070450426f527c565be21"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "4491d31bf1c893bfbae06567a1df646b3cd6e22773c01e4c74acb6d4c6124b76"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "6926f3874508ebc5ecf75a9ae4499427c97e06489a689ae61fca8bb46f779295"
    end
  end

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61c09a42615f9687ba921eaf49d3a5f789fe682fa3b684d73d5dfd5fb697892b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a94affedc1448a651aef77cf7272f6bc24a9d21a841ae7d065fd9fd5dc83e21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c90b62ac37e6c8f5469360b4e42d1407d2e241f230c832d0e591d69bf17a24f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef272c6100a72b0f504d8cf68fbe9ca58af52761021bfe3a1255510f5432629e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab69fa6ad11ec81637762fb58e96e628f11cd7af876283c9f95a02890925cae"
    sha256 cellar: :any_skip_relocation, ventura:        "2cecfa7421a96e88f3ac782901c2ab0b60b97489f2b04e4ad4ebfc8a5a2aa50c"
    sha256 cellar: :any_skip_relocation, monterey:       "46d96a42a9868df7c40f3e6542e08493014acc8ba54a86bd56e96df9b583463a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e4b78cd2af9526750d327338ec7804eb8ed7c3cec46182d4327a161168f46f3"
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
        rm_r(buildpath/"staging"/"testing")
      end
      rm_r(buildpath/"staging")
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
