class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
    tag:      "v0.3.1",
    revision: "e5ff6fdd2d8e08ccfe11b1efc6438d3cbc467152"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/rancher/fleet/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f35d0d4376ac67b6c354c8bb7111ae261275d65b95cff65295dffcfddca778c8" => :catalina
    sha256 "e1739f6e06c70942ceff7f1182e81076feb810314f04ae9d9ac2cd21c0df7626" => :mojave
    sha256 "4eed32c7c3371071608b2a7f0a044fc61165c537ef637dde6cc79cc79b85c35b" => :high_sierra
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
