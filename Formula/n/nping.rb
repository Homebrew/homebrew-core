class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "07ca7ce514b9e9584c33fc6e75c4b4974845deb348833cf92814a34ef4cbaca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cda869d5a41542db6751d52afe76a4ca1833444f82247873a9d1132d2fdf0c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5a35f802efb766b4626a181f5b40bc5c73d24778c6c1b2e84d1bc08e910ba14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f178ee80ca50272e1d0ef634b43f12aa16433b9039eb9d1c4e85f0c8e91d7607"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d622969409b0a7a427e07dff13353c0199a9e0cc9cb65ba9ad55f9f183ff6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75a56f23e207396ebc35b1a60b58e80557da39a6f06ceadc3ab0a48b12613eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3a2ac9599f60c98f5a945f6c24f284628069fca2c7abf9ed81b90846c8ac50"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}/nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nping", "--count", "2", "brew.sh"
  end
end
