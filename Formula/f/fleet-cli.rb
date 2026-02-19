class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "cd2019c5db15f0b37c9f97113869c0b08368af4fecf8ad69a1862cbf6ea41368"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34607fd1793e96234ed825e6b2341e0afbb9dd2fd93f2932e08eef73d514e200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61b43b88591e1cce74645247396d4b9d809cb878942fd2c89dfeab72d8ecc99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f971779a94b94d7e43f03a7b43d23a952b7558d9663552ae07401b507ee9749"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8b1aa3bc3a739580772e922b89fa18e5ddab2d2bee4f877cdda9e883582e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c97cfe45ed92053ee10476933831a1fab53509f354c6ac0944cfa6f9a9007875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74783dc1b1a980be2c00bd3c21c4543cada6185bb576e05f0f6693e1279277ca"
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
