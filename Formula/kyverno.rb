class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.1",
      revision: "4e1789abb03b316b06d5ca46026709a73c246fea"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ee96a9bea8971bab72252c2d61ca3c6585342414968520f0ced51f9822918a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df60b24cda2f5f1bc1fe4b8567e96b0f796c676c6e7766e78bb0034abcaffa35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ec12b3991e8e0e998f7031d4b56fbbd6058e2643ec653e00a9d1a0121d41aa"
    sha256 cellar: :any_skip_relocation, ventura:        "52d50a32391e234d1e4a56b4eb3d2aba3906a42ee5e1b0a34cf5ac29aa937b4d"
    sha256 cellar: :any_skip_relocation, monterey:       "295706cebf41281495a627039dd0b73a4f217dc089f6bf41ae167ff9f28081f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "be3ea88c262a01159408ae8e814fde2e1d328934c37bd6cc9016e19183ecdb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04d8a7e14d48af04ed1ab692f7b104c6ca44c94d575dfffc19ffe6dacbc03bf"
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
