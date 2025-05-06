class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "6ce52bb9664d1316c1cf9e9aee755b4be7599f9c4737337be1d0383c0582f24e"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435a0dbbf0f855d1dbfee1d62310673d835ed08f3de8bd78499a648ac112e3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905b6dc1d9d2ea84a9bb1b573179c443e03ea6428c7b280091b5818f0e23f926"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e866bd5ebea583a26d9edbba9739c3412eef38909fcd0346cbfdeb79e563bf50"
    sha256 cellar: :any_skip_relocation, sonoma:        "645f7a7815baa895b51becf49e1d70bf07013bd29c623b85f4b8fdd0b8f08d30"
    sha256 cellar: :any_skip_relocation, ventura:       "e82f2bf35198e5152af0a588076bb204708eac1ed53a765a221b3739886717c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f550998440b9330c40148db5d9d7e2caee631103e07940d817bf9a0b698d4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "075d7828971ba3b783040c26bb9d1633813efef0abd2cdef1bb428930ed3d37d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
