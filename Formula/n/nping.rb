class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2332facafc52ab150cc1e7932af2cae5c524c6aaa10c192193e0277b53a41030"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b3c52109c69ca82e11c86388004bf3df15c382ad8b53ba7509bb4366ed6855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb02e2f6286cf4558615b4227510752538f1442e3a083e5c76b39c4ac302582"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a123e18d81379c6f08cf219f0e81f022e02abb371483e2daea1d8cdd8cdf8119"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4bf367b25e6b6fcb1e18202fe9600df06291ef40eee9f5dcfb9385a6c9822b"
    sha256 cellar: :any_skip_relocation, ventura:       "b741edce320ae13d462d8abe2d9d4b4f2efe4d73d9c3a655351ffdedb9e90dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b500d9d44a1e3cf1a11f556c0ff58fecabd60e7342fbd86e4a2309f0d6088617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3dba5c232d2fa9d783f9a15d97329ea90ed67897290a0cf24abddce27024f9c"
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
