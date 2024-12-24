class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "9ad494ac11a282c23153fbcb393367f3b4f4806f919ac52a6704118f311835a9"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "942ddd88af660584ba21760a0231ae76ed624806fb57ec46b4c40a99c7db1d7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78007a98c38816c919e822bdca8a3a6ca5eabcdbe13c7f636ea5f4e404a706a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "711834d74b3dd114676cc65079b708c74fccf21be5beae194c1029036d952c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9e5b38e093fc30bd73bde4cb7a7e981da1108ac4a20d276473bd0aaf55ecee"
    sha256 cellar: :any_skip_relocation, ventura:       "dc1b38e62cbcf6f72553d42a3cbb96f6bd836b8edae1e9b3772ddacf0237f340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2867b658833b43939e175000dafd8e6277c145164560b13f5c87089c3d9ab56"
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
