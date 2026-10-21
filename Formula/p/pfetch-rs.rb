class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "620936d3c485a549d22a26633f60aa1cda1ce2745b90ffc634ddb4e1137ffc07"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "407d5be9b40d6a745661818e104416346121411fd106ee34019ea242ba4e164f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02785a4d8887cd3f63f0d26f6cc23063802a78dd4aa79642aa9159875c85c42b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5bccae7834c834709b2e4d4e1ed20db548cac8c8b09ad2080ab1dd23b62767f"
    sha256 cellar: :any,                 arm64_linux:       "14818b61e26b22390403520c9b47850b2f8232bda69b1ad42b787bfde564d561"
    sha256 cellar: :any,                 x86_64_linux:      "803ef7083a391cf70b759be64cfb15a7042e100862dcb20244779538f7f0db34"
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
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
