class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "fd747c05af6bc352626b0afd5f496c43fde23d6658b69b4f08b67533c5a3ca02"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3bab42c8fea3d502b579dda422c17866e0f277a57c360fc942703e3fa01091f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3bab42c8fea3d502b579dda422c17866e0f277a57c360fc942703e3fa01091f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3bab42c8fea3d502b579dda422c17866e0f277a57c360fc942703e3fa01091f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c0851f60d14e0111dddffbc64e0a0d77d67ab608a0e2a9ce2d9deef6065af95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5ab5eada5365d36aec83d963bcd6808ca08fe173777183778e3a17e585a2bd27"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/marmotdata/marmot/internal/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
