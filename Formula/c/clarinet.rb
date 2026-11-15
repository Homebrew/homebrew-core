class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "2966f2de5926e46830df1c3c96486c716eb1ed160c3f563b34b6d0273e0e4062"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2a5d73492cbfe3477637b224975a8ede10677b0058e898964bea38a7226f441"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca571b2f0fbfefc72b9fa7cbc75ccf5eff82175aa2c2e1f9ad7cd3509a41b1c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7b9dfa358fc23415d19093d0e89357b458a608b31c18ce6f5e239bf7b8e6d17"
    sha256 cellar: :any,                 arm64_linux:       "cd6df6317088efe1aae5af4547407f328b3b550d68457b670152f7fd022c5319"
    sha256 cellar: :any,                 x86_64_linux:      "b0f2361a2a099318cb4de3b53dfb5914a3195fa0375951efa105e9ddba0457a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
