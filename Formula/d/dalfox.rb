class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "d86cae222a4db6c8a335013c980d0c6d672b3abee8cfb44da6ce1b489e4d3a9b"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b726844c173b079d2f6488675b8000f0ee996e6e9ac0b3971447837b500f265b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eef416373ad9387fbdaabb0f29c7733cff85776f2f6a6edc62f91b799646bfa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89008c93e722f1a9e7d0f98a5b89d86ad3cc508756bc4dbda0decc5595da6f9d"
    sha256 cellar: :any,                 arm64_linux:       "9263241289ad07df307982b5c33627fe1703762e052604e95a743c7f39d37d35"
    sha256 cellar: :any,                 x86_64_linux:      "b0cbd3dc90892899f64283d96360e8e18beb5674d292ecfb1b90485ac36b6a4f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
