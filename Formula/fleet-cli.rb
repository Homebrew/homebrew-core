class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.2",
      revision: "fbae9ec285468937e759e16179f01a6324d661ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "695b73ebc4a6f540b58351a3bf9478031db796ba3ccafa1c0b54231f79d8e5c1" => :big_sur
    sha256 "18e64d168412856226909f57ea88d844399b79ee16a912b56b624260579c2c21" => :arm64_big_sur
    sha256 "3b67e8efdd84a72182347386c79b28bb792355919ee4e46ad9643f25d37e0b7f" => :catalina
    sha256 "473658446ff24a8873aee2de76d805c1285c7ba62eebd7374c6d339c8f028e02" => :mojave
    sha256 "f43939a331854c0e19236f2b441bb6f68987d0552f57747893e36811e2e9529a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/rancher/fleet/pkg/version.Version=#{version} -X github.com/rancher/fleet/pkg/version.GitCommit=#{commit}",
           "-o", bin/"fleet"
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
