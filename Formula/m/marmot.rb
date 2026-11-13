class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "1006d916fff3b81e3d06a25a6b9fcf78323d0301277c86ad04bf6095176b08f2"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a65d0bac30d6145497fec53fc6a77f84e7561e06756a21cba3f85b96a58519a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a65d0bac30d6145497fec53fc6a77f84e7561e06756a21cba3f85b96a58519a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a65d0bac30d6145497fec53fc6a77f84e7561e06756a21cba3f85b96a58519a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c3a583d8e674a1aeabed2af7b05fd7e46e5450a86644925dd7e4c93a7edd440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca8b6c59e2f595b69f7075a3efe9fb789004065e0a51483da32be54afab9ae63"
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
