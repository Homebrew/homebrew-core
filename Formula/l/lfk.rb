class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "221310c13e328f98414b2b1875d7738c2e592a8b703ec559d6525f83225e38d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a64758786f153c97554125a5e815d5b36f5a50e83dc2b90f39aae1ab5f3ac23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8c9ef949a91218655f3637c271db2c3974a27a1bf63b3ef9bfd9d234d29fb03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f62520f55d80e22a8a4a79e04dc769925c0d268dce84218365868b99b7f6875"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c80482c3dc40f4d3cc08c4f96d782cae9616caf2e53a7bb185f0f9867a24da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085c18a5ab01440bab7980babd93222efbb8c29f858449b8c7d8750c0b91242f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df5d6763a225153b3ae5c46d41a89960eb6eb5496560bd447873dab37cf890b4"
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
