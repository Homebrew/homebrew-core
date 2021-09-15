class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.15.4.tar.gz"
  sha256 "537470d894afe833a0e68cfa0d2c412869333882a46216e9f7acbd8bd9f1250d"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a9b2e521fe5e66cba644d6dc043800cb3eff7f97a066ef4b6ddd456126a1d34"
    sha256 cellar: :any_skip_relocation, big_sur:       "87fceee7cbd520036bc3dd933fc8053f6f49e55b904edff11b3e82c2c627869c"
    sha256 cellar: :any_skip_relocation, catalina:      "5223ca004c271a7b9c99c997736229e66647defaa90b3dbb1635571fbb1a2ecf"
    sha256 cellar: :any_skip_relocation, mojave:        "95188c7f64a9ad82dbcd0ca36edda7789dc33dd7433dfdc30c22281a37be2a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940e71c7b0abb56f4af2b796e8e09b87fb0f3a9fa39206fe86a8b45adc22d160"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
