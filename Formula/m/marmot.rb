class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "5fcbeb16b1194601d4deeea503c99856a6f340be11d20bb450f204fe1730a344"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5962096b6ff3807feb774a2ed1d0eaf95162f25f6f65726db2a2cf7e52a9f2ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5962096b6ff3807feb774a2ed1d0eaf95162f25f6f65726db2a2cf7e52a9f2ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5962096b6ff3807feb774a2ed1d0eaf95162f25f6f65726db2a2cf7e52a9f2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9045f1c867d7de97d81acb148570e8e5cf3599ed3235d71d74e2ab8f7ff0402c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "81ad05260d78e381ede8781cbfd5165480cd572dd08b20e512643372f288c08a"
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
