class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "e78ec7c02ec9437c079bbe95e4355ca7c9704ee043f2310cce2b512a195e58f4"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d20ef1dc5ca02e824b4791f9e3f5937df88299915a921687bc1cafc76a784f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d935a5cd541db1690d74331ba7526100f17bf11bba45d23b87d47c9689a4a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f339d005348d2a781bcb337b189dd897f9ce36329c3a6e9cca834dff880739e"
    sha256 cellar: :any_skip_relocation, sonoma:         "11ac0be70c9528b536f76bf4fba0ca2b35c7eba2d35542f1656c92bcd81fe167"
    sha256 cellar: :any_skip_relocation, ventura:        "d929b6481bc9c0d61d489621cd61e3c3ea967ffb6488ccd7ad8a1a5d4c10c40b"
    sha256 cellar: :any_skip_relocation, monterey:       "d674b1c7624e64dac24f580f6fe3493dea149bdb700a1df80bcb2c6a2da3ae74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32b705dd461178aba0134d3c4ae0634d0c226e0efb12b19994d829ee0cc6bc8"
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
