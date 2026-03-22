class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "47cb524ae8460e87d05b80364af764b9c188075f6d3973983f4589b87b573c42"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32bc9b10aedb02b21b2ce0326de84f5c3296457f5b86a195a0884e9ba0d0f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b163b1bb13aa66fad21c30084a36e0b21d0398ba2d0e67ff45b51ed560655859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251fb5d9141ce86869bd73c7c5e1f6b0e8f8ffbc926deb33c11ca0375e18eb56"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a23f517fded5a6196569601a4dee59263fa6bb3659473beae06be7bb179984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c272a4f0d02583ccc4938dd9058535524ab6f9d48207aa588d4859c1236f49e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f7eaf82a651a173e78c1b2bc80510b0a7af10d847390032efeacf530caa3d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
