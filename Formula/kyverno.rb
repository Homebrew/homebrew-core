class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.8.4",
      revision: "0675d21dd9586a8e55ac2b3796a8db850b996895"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aedac81513e1e59ebfbc7076c79a06f410a3619933f76e4499044b8006d5d660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49e1b3c3010599d213ec5971499506931859f803320631c769f94dddb38ddf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41cf9e49c82b0eeaf67559eb10f2f1cbe9a3cfa34a2298bf325a913765ab4dfc"
    sha256 cellar: :any_skip_relocation, ventura:        "45d3f75a2d350f0dd4f25b604c913c8810f447115e1e361e3f90af2ff41bd9ad"
    sha256 cellar: :any_skip_relocation, monterey:       "74e0c732b93fb098a7caf853af5bfa1e0f5eac3488188bedd0067a9e71078a2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d78f6c15cc6bf50f79bd5a7f0cf52d2da009f71e72c96759d1c5d1560dce28a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415babb1db9a01d922d86bb7025a68350164aabcf95935622515ba44a0239ba2"
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
