class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from https://github.com/mozilla/geckodriver/releases
    hg_revision = "90ec81285ff6287cb2824b29ddebb7818cc7b96b"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.27.0"
    sha256 "06d92c830016edd9c4f88c9a659343fd9c35cae168820f6808f5486b3e42456f"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "88ceccaba4df4ba57bdf3c9238a9834695fb51d67b749e37e1c158662ea2a6ef"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "65c723351868f2a8b2c8dc7cb72b06ed0372dbef34ca21420162cf870c4f8b5a"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "cb3d9f8f6daa3bc5cb884312c03cbd25fc754e7899c6c3ed90c452d1a90cb6ae"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd5e9db1c72e65e9af516a5c8bc43c8896808b636b036b1467447418cb34a235" => :catalina
    sha256 "d4d308dede5f3762694b6da1d21426e470bc8973b8e0084e1a44272b9673204d" => :mojave
    sha256 "c1ccd105a99db9ad2cdbba28d2502ff3a215479e83248b419c44799c0ee68dec" => :high_sierra
  end

  depends_on "rust" => :build

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
