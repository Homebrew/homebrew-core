class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e810c7faa7d5c05e25b796e30b29449b06254071653b6d042828c59d1efc91dc"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7653b5efea8ba1e5362ae9608b02e4700aea8a4031b7e5c2ba645d012f16074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ff94fd8087e3945774f722ff77b9ccc23ac88f299e9a0b7e99d70d8d849646a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff20811066e3af989c40d5361f21c90e2b31ddcfa19edaaff586b56d78ce2f21"
    sha256 cellar: :any,                 arm64_linux:       "537c71ddc3e4b130dccca49aa73443a463b16578246c756b939555e6ce2a27cd"
    sha256 cellar: :any,                 x86_64_linux:      "d3605d6bb1a6af4803dddef2c831dfeb7c029c1e5ff65f6dd11573efee3bffa0"
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
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end
