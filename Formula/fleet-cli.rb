class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.3",
      revision: "c17a2f2cd69df7ac028ae9c0dd8ae3ea1e492f2b"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cbeb2c468c086fa58b37fe893676e8513a3157ead23ae4458fc8200374134e0f" => :big_sur
    sha256 "1fc1160faf02f1a81da9cb77acfa1afef1de9ba27318b246fc3803c38b1268f4" => :arm64_big_sur
    sha256 "a7f6a234baac314527226325e09e820a3005f535fd8bf0dbbddce12b7cd59d58" => :catalina
    sha256 "84883f4961ecadc2fcd27001ed56c839bfc7cc0e3119cf8335cd22a85313e816" => :mojave
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
