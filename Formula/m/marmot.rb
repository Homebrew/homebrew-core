class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "7e044e9fda5615a498b7a63049e04f56a8eba692f69a9076cdd8ea1ab6ce48a8"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1edfb25fc55715bb7576101152bfe47271f8f0200e3debb4dc0b47abe365364"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1edfb25fc55715bb7576101152bfe47271f8f0200e3debb4dc0b47abe365364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1edfb25fc55715bb7576101152bfe47271f8f0200e3debb4dc0b47abe365364"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1079e65df59837632d43ab4af0c41160553a06ed201ec6853bb39b69d55a2f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cd77835fdc4991e3ba08283d243cf428e2c37f4c0844c60d79b4c2e26c0532b9"
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
