class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "95e8d4c6adefd672474227e819403b31b4030c00c29296f37fa5591af5d455b2"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f446733bdca37000feddf78d7c2d68e29d87fbd157b9985e597c87fa7a814b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7534a8c103c40baa5df60dc6c1d5bf754fe2cef76e337b121a2237d0cd9e44c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dc9960d36426c43b238590c78c64320631ecd2be8a9fa1f1a9549e58fd89e32"
    sha256 cellar: :any_skip_relocation, sonoma:        "501b486f0e939a53e2753635e757347128f3cc4c0aaa821feb3922bae467d60c"
    sha256 cellar: :any_skip_relocation, ventura:       "20b4f719cf98d9e15ddc359ff1b5f7da536108d706a1e11eda7679ffb6d1918f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52b2b44d7b34040c1dfb5e5f328c478bf880f1e1eb84e9ac139113c7050da8d"
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
