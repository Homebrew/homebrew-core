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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0a4dd3b36cb9efe8bc78922860c62231c10ebdc43ec387d36c79abeef97b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "088b958a7e65eb2364552744f6f303657379e8a448b756bf8b56545e37237b39"
    sha256 cellar: :any_skip_relocation, monterey:       "b81471310eedef9dc63c18632c45bf0e2521c302011f372a500076ba1c5e452a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a575e74700d92fca086d97f0eedc0008666c0169c3837ce90519365364a1b78"
    sha256 cellar: :any_skip_relocation, catalina:       "21aed48d04a0f5a3b47fc3abbf2b5f3b54364cec58ca4116632fc100b0a36735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2dc70b3bedbd1ab8802378656f35e06c4a06a5cd6b4ee8da2d38c928206a6fc"
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
