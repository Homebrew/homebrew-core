class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.16.tar.gz"
  sha256 "a80cefa3865a5490436ab736d3bae530ce676792a1517b6a202983b5e5f037f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d0ee26f864019bff88b269f7cea05680c5cf3fb970b161762834d060dc341cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d0ee26f864019bff88b269f7cea05680c5cf3fb970b161762834d060dc341cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d0ee26f864019bff88b269f7cea05680c5cf3fb970b161762834d060dc341cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d01e05120ef52d8626eacf78662005f30f3502b6f72ed77241f0cef2ed3940c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9d22d0f1c727de5fd225a5c9cec261329282340fa8b346b45fe1704b70022e93"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
