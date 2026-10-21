class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.37.5.tar.gz"
  sha256 "e2d48ce9497af0efab47efaa1adb9c6f136d307ecd3abc5f198e0592af852f68"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f961a4890327fba706d8bb159d065f23b2ab9f3136f3e7e184ec9ab30a85950a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0122c54872f81858e615b755d62f6ba9868b1b5cf924d27b9dec9edfdb3f7a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5309d248570b81df54e3162af360fc5df966070027385cbad41aa1acde261458"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1884b49d5d1ad90517710af7d1a32feeee114fca1831ee3667ce0cab63b7a999"
    sha256 cellar: :any,                 x86_64_linux:      "e5bda1df2eb58097a27541ff7b1df4abb5ec5d400da53418e3f5f1dc1381e817"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
