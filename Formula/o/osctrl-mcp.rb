class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "7f6e4a260f24d37f19bc955d42bb0babfc1224af43e8db7d017f21c326404df0"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39c6aa0a921b5ae0524933399f2f5ce049c6af5881c9d6866edbe05be5fb3923"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ba1c62378c522bd2a80c2e53e355aabb3634baa5c91520d4e806972ae502778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b526e829adc4423ced5269a8504f949b168c949bd6bd8aae716e868162c5c9c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7f6009b76592626dcaef2da176bbb339120f1f128c9958fd780a29946198305"
    sha256 cellar: :any,                 x86_64_linux:      "5c761627799ad41e27e80701778becf1bee08bf774b090fe0290890844005be6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_head : Utils::Git.get_tar_commit_id(cached_download)
    ldflags = %W[
      -X main.buildVersion=#{version}
      -X main.buildCommit=#{commit}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-mcp --version")

    output = shell_output("#{bin}/osctrl-mcp --api-url aaa 2>&1", 1)
    assert_match "no API token", output
  end
end
