class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.5",
      revision: "f414eab0e4de0523eca797fa7bf47fccb1997e4a"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fcee1d2ca3150e65cbd7a6237e9c38e4385fc73bd5ff39b7226f5fdc62bce51"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ca409fed1d4771ff13aca203aefcb3e309ab7ab96483d78ead004d238f7a308"
    sha256 cellar: :any_skip_relocation, catalina:      "ee38189b4740f9ac1f0f2c0112b9287806d23818615bd6ab72da83d60670c51c"
    sha256 cellar: :any_skip_relocation, mojave:        "1d2022964b99813e6b3778de6ffa98ac95435c1da3c63e90eeb2ec94a851bab6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"fleet"
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
