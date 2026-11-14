class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.4.tar.gz"
  sha256 "70e1de55151eb5a15ed54dba588a26db6fefc70d228d5d9ad5a5cf88cee8302e"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38e1598004958fc48426516d02238e4abda12fb2563b80ada6e3746c9d29f9c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5563d2aaafb60a5ef4cce0cf1348d1a20fe27b3f61528314fd2e3fd74d62a4e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62a44bbb1311f792d2905621a16c837585eeb2f5a389268999025c33928aa947"
    sha256 cellar: :any,                 arm64_linux:       "d80db2697a83535f0eece86d1d732df47b2374d3b82f8fe28c2574ae40be93dd"
    sha256 cellar: :any,                 x86_64_linux:      "a50beb9ffd8baf647f670f21b3d984654127cab74f79e0f87fecff230b0a244f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
