class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "f7415c459d31e0ea499c76a39386f59523370dc6c8b571aa9118f8f3ce176935"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4fb1349c84effd92e209badf53de0e34d9af9dfc0d16ea6478f0657242838a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bcaa13532af67654d5c2339aad05606d7262476e9b218d014883cba03b9755c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac2f03166686a4d49219ba54070105b0da35db019bdf3ebbd7c69adee1e8082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b17c5204a7eaa20d89938d9c3706b5c907dbb88ef81936b0546293002fead2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1598e9636f26de7ed77151531fb67a72497ee4742bf4806af09983b9418a6ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7da6f10d1a52c5f5e7fb0c905db80f58b2a059a2608e260ea707349e4a8be8"
    sha256 cellar: :any_skip_relocation, monterey:       "4a15d8d3c2d2841c9ef007d491a45ce5a3622a670f683f940c7b5737f57d0f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2fbd91a83fb5aa08260886d2e50a30c44ea76195a2bdda3179d0ba8eeb01aa"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
