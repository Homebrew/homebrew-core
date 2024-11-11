class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a00c279c367045d076a8b7ce546b97a18edf133c62bf439f97edb9895764b6d3"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b37a8080f7dba1e10417a7c4bb61ed7cb69cf18bdc40967e4efa8c1211c2f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cbfeeed5dd9400b4719d802625366359126add980f84c08f360f23a07057f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c13eee9132080392462b370c7ab2c15813628a78e1c22af238ce5b96476e7d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3e63bd304102a0717dbf096b8b94d1f82bd760683a03e6854a217e6e13e569"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c23b2054669fe043110c60a59477ae9485c116e87e96819f7d5a960ae33827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef755a93db8c8d748c17678659c4ab664d33e4e9c730afd590e39aaed43440db"
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
