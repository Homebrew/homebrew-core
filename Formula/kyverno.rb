class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.7.1",
      revision: "060b12d2a281720a29c0de99ea860a6db1c95c6a"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "504db0e3380ca6862354cdf00b712c1c129060d1436aa503706273eca7ca83cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b97caa9853810b49d8c413e4f49e88d442d714bf62634864bb1f4ea289f2af15"
    sha256 cellar: :any_skip_relocation, monterey:       "12022ef909ffef9ac367306f21dbdf7095df28c62fab584073900ee92a235eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb20754cb89bd96b53a5288112b7bac295151457637ace18d2a48ac4d2d8c912"
    sha256 cellar: :any_skip_relocation, catalina:       "828d3875757555b12ead6ea11f787e28dd33ab249505d7999c49f97e7db66428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c121eb811bc56a14800955ed7c82bad8eda9b7feb3e859278eade11c8f4b831b"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    (bash_completion/"kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "bash")
    (zsh_completion/"_kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "zsh")
    (fish_completion/"kyverno.fish").write Utils.safe_popen_read(bin/"kyverno", "completion", "fish")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
