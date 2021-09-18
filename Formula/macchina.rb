class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.1.6.tar.gz"
  sha256 "7f721c3498e9db2d9340d9ac50bb2561b2d2629415143a7742efd9c904b92000"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff249a309e3fa5078554168cb5ffec2e7e61ac53fc74b4ec1cff5b6385804e5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c39e3a18243f86573ce9b3c4f02549beeb0a18a353d5c9d9910ce098baab4cd"
    sha256 cellar: :any_skip_relocation, catalina:      "9ec42a5141d82c7cc9cf5a293085129d97043e4f0d16891d8cb98adcf3ece8a6"
    sha256 cellar: :any_skip_relocation, mojave:        "d031dd6d9439ff9d7526a0d22e93e851dd53a89baee4e7de131a9b6b86d7fd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357f722814f34b08d13df030dea84abf1c1b854cba449ee644a5a7bda599f0c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
