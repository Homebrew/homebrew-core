class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    # Get long hash via `https://hg.mozilla.org/mozilla-central/rev/<commit-short-hash>`
    hg_revision = "bc25087baba17c78246db06bcab71c299fd8f46f"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.34.0"
    sha256 "2282fe6ab8cca3fadbf496b68bbc08632e3084469306ca45ddf757c60232822f"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "e18be4234433080dff4da5cd9ec5948a33fd38b14b069f4204bb1e4d6fdd0de7"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "441ef05f4f66d9362c3064dc65c305f56ef1e7be6bd3d648d0d5c1b0fa6a4940"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "19452b7f17cae89d6b7b8e4fad55ced0a95fa6cd850299733fcd237f598363d1"
    end
  end

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1885b9935410051ef03a37966cd99709ac7136ade7ddc9603d985e8dd928d9b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "134409c16526edfc09a1dad7ab231f3c2bee371bbcf54ba105d4bc76acab0d00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f5a089e7419f0eed816a4a083239ba5ee8ebb8be63ccec96d400db0f29f55f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3204723ca99bc6a88af19d5ccad0c26aa3f1743cedc09762b54cad4481ee51"
    sha256 cellar: :any_skip_relocation, ventura:        "dfa295ea1696bdaaf598759440224dc336f9bba371efda80b0d8791b339816d2"
    sha256 cellar: :any_skip_relocation, monterey:       "ff3d2092d930ebae80cde07b8ad67cd7bed2dab24baff4f353461e24d4fa7a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a0c5687b091d35676a7d803e9330db700578314fbf422ba95e059eb521bea0"
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
