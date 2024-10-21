class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "425fb5aec5e7526bc90064f9ae64777a457f663a6aaeaf175bef2b6015a7f02c"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b877afedf6b9e584a53817770b49184be81b17017c7270a85756271335100a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac313f0d1b62d6780ffe032746d819f0002ea45bd64f0579e3c7f90229d2291a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef590cc9cbf7699e03fd64b76e2053448b4e4b7aaa9f69cf3903588d4e57ea75"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef5f6c9f3c77652ff43768e690eeeb84d2c47a342f4c2530cd48be5165bb129"
    sha256 cellar: :any_skip_relocation, ventura:       "46e6f09d4238ae29b1cee4c60ad060fe791a367a2121da8ff705c70f20d0ee4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8356e1eca75075deafbb8cd11a2d362e1326346819c212d182796f7402e4f9b9"
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
