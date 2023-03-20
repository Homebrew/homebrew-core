class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.5.3",
      revision: "b90a1d37a79da99a273ec67f7127eb657bf5f5ea"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "752e257f208258ab3d66ae6c151ca9a80c15d1e46a423e9444d2c6b66ce0e693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81bbb2f39268eb89e9fd9bd50d91b69bbb46b86094d2483c9baca4d3884f0fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d65c26fa246ba4f7744315c3d02015bac07c023715ad983eb1e054ea6bf7c45"
    sha256 cellar: :any_skip_relocation, ventura:        "929756fa39c7a422dc4ef2ad77b6ea7634516ae8516469468ca77d866c30a894"
    sha256 cellar: :any_skip_relocation, monterey:       "aaec9d03f270e06be771c81cbd5adabee430ae9f643757c55366cd677b530bf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b43fbd5f9f2f2f65c62a5033cbd1e87398bfa3b8ddd8e2b6d468cc6cc4e75a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f664c868548385d5c1862dc9af3fec363c0d869bed6e96080ea05b62548bad4a"
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
