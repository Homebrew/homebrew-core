class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.9",
      revision: "4dc66c946ca2f90f5f7a5d360a573698687a3a11"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280ef3f8c1119e8528b29eb8ef1f760bbfdc52cb96a61d85d31d95e8a39613ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd14343cad71726639a25e958abd209a80e1b900127166f21e6ceab913fc0c6a"
    sha256 cellar: :any_skip_relocation, monterey:       "82e4fdab537813324e26da8d52cc0b31bef0d3d9295448ad0d0a80e03c8b167f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd09e999a485b60c51ae0fadcee13131af10c404f14a43b0d155efced0f195f"
    sha256 cellar: :any_skip_relocation, catalina:       "70e3819ec83c06f5e30f1cefc4e4630657ecb580921c7ab4747b35cd1c3ceaa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1edb0bffae842c618780e171e38fd588e0c5f4e9c818a8e958cc5fbdb492c321"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
