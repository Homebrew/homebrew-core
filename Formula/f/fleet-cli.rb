class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "63408c6c225d43fea36410defe3b7d56f17e5c84b857eaa2fae97fdaeb80d20d"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f2de638d5efa8d059b629fd47bfe67e7630ea189966b058be54f13200e77cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73da9bab780aff6763dd614906070318700a35fb8c1f63bfd79647c4f82c180c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad0b65c08fe426b69c61d4bf384a43269778f90f15c11a234d4162cd06898fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb51ce36076a3430a4bddd8b153780cb25388c6e060de1a039e7899824764878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9e28f6e88ad7e052e4c2ca872734b3ec6e73a1d02332d800dd567cff70cb3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8203649b7ed0c07551d639f3e687bed8e82a6939c31c759e11b82a9642774ebe"
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
