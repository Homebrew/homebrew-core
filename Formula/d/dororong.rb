class Dororong < Formula
  desc "Fun terminal animation app with dancing characters"
  homepage "https://github.com/AbletonPilot/dororong"
  url "https://github.com/AbletonPilot/dororong/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4fca3377d862165fdef8d700f0582528cb92f4619ad9ff2b45cf39add61b0a94"
  license "MIT"
  head "https://github.com/AbletonPilot/dororong.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "dororong", shell_output("#{bin}/dororong --help")
    assert_match "0.1.0", shell_output("#{bin}/dororong --version")
  end
end
