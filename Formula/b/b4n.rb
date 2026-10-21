class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e64b874aae85ff3759d5082339688c9a6ff3ef8326e327b0014b0eba8385a5d7"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d88d63e8116cc2542c4711c14cfb92e54a7b5b0baec702b1f521717626f352b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c4fa178946e9fc1d812c3ec36b73fcbef0990a1156d5cc5988cfb1c6d2b8143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c02a3a57b5c2f2d40bd40933821f0d8d0c6244712f278467ce7643dda04fa0ce"
    sha256 cellar: :any,                 arm64_linux:       "1fb4bf34c47511e3b0c8735c825af3d6d8af5f381a57306708af5030fa54c9f5"
    sha256 cellar: :any,                 x86_64_linux:      "5023ee470e1d9db12de171726d8bdad2d8ad383c8429017994e5f45a5aa36ba3"
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
