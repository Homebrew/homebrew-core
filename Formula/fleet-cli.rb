class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.5.2",
      revision: "e3abab9ad44675527e861fe65c332139f189378f"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f10d869e0e3cd4530fa6fd017daf0ea3080228d77734d1cb7d0f314baa376bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7838e3198d7c39da1bb47a2de19265e176cb9ec8378a87d94133c2d80a0649d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a2f1367f90f80dd39f50b0a5e05c0ab09c56467852e97529f42fc145b66f3a"
    sha256 cellar: :any_skip_relocation, ventura:        "a58667b4c2bed6eb0002a12d25c57755781ff810b6ffd9c2243d22eb4f443fc5"
    sha256 cellar: :any_skip_relocation, monterey:       "5a748e9eca21913d338ff182cd665c2d0cc057de0a0c115e3f288abf7e5237f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6904dfbb4ed3d1fa7867a7cd60bda35e91f01856a6332605c264754d9c5a25f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e432fa51209b8e6242466f89142da6a29d24f72bdf8df7d81c851d267201b0f9"
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
