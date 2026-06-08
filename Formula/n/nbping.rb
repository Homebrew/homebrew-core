class Nbping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "344d49df5a117be5b52662113c84581f8b8c245b3f50cae40bbb944a4fce89c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "625e690b7582d4d189badfebff0500f2e9441e4898cef08bbea8c5c293f00933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44177c9497a794ae77d79d80d92edd5cc79b0bb8f545f929886ab64489cde4e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7dfe5cab7431bc0057affd87d89f58fbbf7d32aaefcddbbc81a9e3e93c8d94f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa1c814f94c2683f16361f473068bc4b7dabecd7626a118df74f77b6678935d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b469f18b32f694f0610b98cad74975fc1781d82e4832cb265d0beea09bba5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77e799254eeb959040edec57f0efb47c877b2a776ff7afcb9682ec4eebc7ea8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nbping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nbping", "--count", "2", "brew.sh"
  end
end
