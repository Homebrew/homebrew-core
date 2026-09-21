class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "c5874e2790aa21def45dd0ed9bd932ef2666ad412839f307c93c6a1bd94c20f5"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaa2e76931973587392620b5b9d65693858e217fb39080a588153c0c78465626"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "848f5db3e8bb9b092ceb70a54c18782c9e93cf3a175ca7c22c1b69f91c6b1294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "982bd9e09928052eff17574347e0b4de06738a582cadc72976f49b5c0feca7f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "283c1448096f484f6ac928230f5ab25526425c9a19e27e1a32f1f8878b2c484b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2798e956392d97be889f1697594b9de95a40ce05afbb01a7e892874e328975e1"
    sha256 cellar: :any,                 x86_64_linux:      "8de25d4b23c7bd815b7200f7587b4796ae58c8023af2555402bd56442d40faf9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
