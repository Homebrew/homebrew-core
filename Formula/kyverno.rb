class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.8.2",
      revision: "540f133fdd1f78d394a2ec31658361b9cdc57a33"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0609364d32497a34dfecfc107180e664a759536c9e5459757f2fc7e3486a15e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d36ca159be5f19d85335580ae8bcddc6b8fb674d3fcc804a3475d4b48688ab6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "828d3f44d6b5ce1f4773c7b08d122ebcd3ca24877a518f69603e4a210643dffb"
    sha256 cellar: :any_skip_relocation, ventura:        "73a4fda64a8c5ee6a0d65ee7ebc4f2f57f9d3645808cebbda99579648bd513a9"
    sha256 cellar: :any_skip_relocation, monterey:       "8454f21bd5ecc15783708c43b718a6171b50c4d5f1f14e7aae167276f216c36a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c61c546869c192f07d6a29b9dd6729c8362a9ecba0450aa3af909885e5298163"
    sha256 cellar: :any_skip_relocation, catalina:       "e672d1af67899c811666537318caf8dbc7b688681565bfe42a1ecda3b245b365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ce711bf3b5586db642ffb60f9798cb4b88fd3082ab4946b0ffe476bae67a5b"
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

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
