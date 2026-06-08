class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "a69316dcaf6d84702ee0498c90c5a1fe7c0c4d9936d16544544693794f6ad2b2"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5794b4fbac0acf06885ff061f9b5ad12465bc5633346fc6a1eb61f6cfa01a36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "660c6c433ffb439a96f090d7d66327a4ae32541d4aeee6636b1c79326612a411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d680cd09c084304de21dacfba7d7c123d1ad8e4b0c7e8d57e04f93904e70d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4ccc517ff736c8aed1d5128cdc2d0098d1b27a256d0d879803f25025f95d557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2db8858b2ae7568d1facca80b092242554d663b8155669a03201673bc5a61060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa8bf6e8808e9565b2dd484998a77addf2405066a1f18aed1727c9966612266"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
