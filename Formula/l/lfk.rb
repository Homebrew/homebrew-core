class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "9a788d709ca1eec04b3f1b107e2a2a2a577a4486d63fda5810883341d3021b62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce93aa68e7e44651bde8f047e2248b4dd69e9cfdff14968a44910256971b633d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7147d81ec950603d7a1f84faf6149f6ebe84092a14b204eccf674b89a69d649"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aa43dd4ca2ed57e31d1917a32c18bf83aac926749658411146825e12e5fea35"
    sha256 cellar: :any_skip_relocation, sonoma:        "f872209a4efb0d279d3c10f41b0cdc96a54eb133f62680aa0adb6fa34942c189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a4aaeea5848f4477770dbe6867189969c9002343022947802fa936ce49ecfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ce4a41954ffedb6eb9ba7a32bb8165d0c7d0445ac19488ba7c68d5462019b2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
