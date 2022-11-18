class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.31.1.tar.gz"
  sha256 "ddb7bde503ef990c95c762863f4c858499f17c00d8e6ded7885b4fbbf1600250"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a1a27651e6a980469d6d0445b885ede52881e708faa856366936e263eb54644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c2223b6fb019578914eb9c7a1afa52692e42ed8c0f5a55299ce193637c29b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af121ea95ec198689ebaa428b3494d8fd24992929af97dff495f5ae418465383"
    sha256 cellar: :any_skip_relocation, ventura:        "5b27fce7da04ec03b037a936be86405b3bab59f14714e098561e7782f55b2390"
    sha256 cellar: :any_skip_relocation, monterey:       "134a5c7477b34579a505c2b6fc47657280177eb1759ac2eb7884ceb828bb6527"
    sha256 cellar: :any_skip_relocation, big_sur:        "10c2190512f1ed282045b85b4867c476c57ec7e970ad35289046ac36d39caea5"
    sha256 cellar: :any_skip_relocation, catalina:       "d933091825ab2a9424b6f64d857ff048ad5fc0b20843968b5bc739a714ba8d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e14c44d22976b02568c98b5a3c089a15931dedf1d3b3fb60cdd94d2f671ed8f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
