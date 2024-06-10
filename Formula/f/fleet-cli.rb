class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "6aaebcf7d52594c527083f4bdc74fadfc2fb881c0afa6b334b238712ed6b71c4"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a1a3c29f89bd6d9ad361c033daae11b20da74dbb492b5217e00c07ec5c86bd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b67784293fd371cbd83fe43f8cdd57a689ffd59bc410612b0341908755bb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8fd96b41ebcf7410f32664b7b84cfb645660e7a82fa548b27a4e6175657b52f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8702aab177fd94bbbc022a783aa7b73a8c19d95fea3d2b9d854212876acfd26e"
    sha256 cellar: :any_skip_relocation, ventura:        "75010bfe1746e2f02af50c77879ccc0e04b6c081a8ee24470b842b5a28d20638"
    sha256 cellar: :any_skip_relocation, monterey:       "520adde85b87393e4e64994230efe928ce6e2a5853a8db74f925ddb745375fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dc1db05313c20faa06ff4f4b52602df99ab8eb99574a2a2fad756806fa2fc39"
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
