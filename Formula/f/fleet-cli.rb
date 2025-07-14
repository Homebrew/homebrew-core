class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "d47108917eca6c2fa981a6b10553907d27a9817d68d5057405abb01934d1afcd"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b309dd9cd9f63ec618d1558fcad9d400c5ba4f8ce1a27fcd41bce3deade22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5358249b320567b20fe7306b68c1e4344a66255524c8380def2bc1e19f7ee35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e181508dd531afed5d4a58151a5e7580c02ee550f1030ed899101b543bcd8f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a541b67f1141ea46847000daf95679fea185beb6858b324def559e721b6bb2"
    sha256 cellar: :any_skip_relocation, ventura:       "0c4966e49c7a84e999a1db07957fd5017c74efa2d1552b74a4209d4d3ee35282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe23773dfef369745f6e22f1953a2685ed60ad875580f25b4cefcda34da2c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52f60fc1df41aa6c790e0ab9a8e7f1599f9089ebe0bf994e6082dbf4ce77076"
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
