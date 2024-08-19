class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "266088bd1962350593478f4f09ad0dcb8825d1e2c0c3b4ef59600f8f3da883e6"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4608ed9bed08f86ad2e1e59421fde853a10ce52e9f230f22ffa7b38b397c3030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b9f3398f67aef2f671b6d432aa6f18e0eff927b562b6dc02f317bba9c82726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ec34ca7d11c8605dcf87cacf0673f0c732b79e668cd95be829390e17af1d209"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b2e8cdee189da106c81a84a39115532144d725dab6c056f2a242d16501a58c1"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6ac4e43d8eef48320d57324a972e2ae2384bc00bce0d38f264e492bbf22d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "2fdeba3b857d9ad2e12ac331f3424e98dd409f34bea9b86544c504989baceb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cee08f34dfae6417d4c24a54409c120a826eaaae1790c6f140ab474cec0a8b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
