class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.6.3.crate"
  sha256 "8559fe476ecdbeb38d75896c817fa275ace1502cbe19e17f19bc9e81e735de2a"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49d78d9fd0e9a536aa0f29ab6765fc835c9e47b900bf81898c28628403f3a384"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68fc56d3cd07c8df4f635caca6cebd9b9138848ef11f43e25c5a556c4b78bc69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3c5ddd241bfed931325824782c1ccc6c16f1536985a4189eb6483d3bbd4f056"
    sha256 cellar: :any,                 arm64_linux:       "c552d434eb493c0d61b90de6ec2cdd966b83359a5559945c6eb2e876ec7c7b79"
    sha256 cellar: :any,                 x86_64_linux:      "d6641c7a6f8ba8b89ca995f0a3554a40e991c12f412987574227449d5a9e8d31"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
