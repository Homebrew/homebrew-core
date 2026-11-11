class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "7f6e4a260f24d37f19bc955d42bb0babfc1224af43e8db7d017f21c326404df0"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd92c3a19787a7e9c238a28ded4c32de2ae5ab8d899a5e4f05abd22bda8a2306"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6593952b8dbd02da13ffa61af0a5bba6734412b170131ee6cc7abbc9b91ed8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2daaf48606101b5bd93300b95c73989d8346178a1100fa57f2e297790413f28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4dbae2e77fed5af363e327af97937defe9f368fc11f1cd465a7dc8d27031475"
    sha256 cellar: :any,                 x86_64_linux:      "2943c3e643f541cc5b4ed988d0a9276c6456dcd486a5c8f67de8517de28fdc26"
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
