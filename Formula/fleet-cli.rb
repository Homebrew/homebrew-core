class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.3",
      revision: "c17a2f2cd69df7ac028ae9c0dd8ae3ea1e492f2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a1f01f7113e7fa81badd8df6cf0fc99fa63c1d59caad4e069b8887018fe0fa9" => :big_sur
    sha256 "73db193930307d0d984bab4a344dee75352da261e6d8a6a7185c44a63c5956c7" => :arm64_big_sur
    sha256 "51b6b5e60688924305aea43ac8ad943b37f9a3d56ea793d04313b88a5f076d31" => :catalina
    sha256 "c84842ca0a71c38e5ac006a88707ee8e80ac60f18e4e80110c33f3786b52744f" => :mojave
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
