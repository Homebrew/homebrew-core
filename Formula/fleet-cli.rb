class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.4.0",
      revision: "eae202f68985ce20ff8f97586cd31ee64e7df020"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a27fafa5284bcb69dcee8656a8482f1e4f825be65f3c4d0ee2e9dbbf84e568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e5b0110d36701c5c2047b3f06420acd3ed3508457a691c1946a33799b0abeca"
    sha256 cellar: :any_skip_relocation, monterey:       "5628f1b8da507f7c24ff26e6c1deaf3178f242742391aea6932ac405b7dc7021"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29309899b38635d4837600296f991ea023e8d1d9e8242772950cb9f62dd2dae"
    sha256 cellar: :any_skip_relocation, catalina:       "54629de7c86686a125dcc42953f551f0c5fc97a89cc5b6448953a970d5f05299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d1302b8c8e61bc649938bd0b56075cc8058ca1a0308ca2a3a0aa92c0111b14"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
