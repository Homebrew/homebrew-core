class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "c3189decb979989ed864e20d0e9e884d0a7a2675d24b19414068b5662cb05349"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1855ea5c0685ecbcf31fb885c824404b4397f63f19f9cee666c3adf54cb7cc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c84a8f62a70537aa1a52e7c4059a3807ea68c6b9b3a90e13369231b3ca49e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b9c518dc61ae4e9d1bf8d3c714835bd31bdc7e63ae3f80f6312265a7c513dba"
    sha256 cellar: :any_skip_relocation, sonoma:        "996725ecf7686ba407b3f3a2f3aec83a8d42dc86c9656552b9373bad45827a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976c18ffab264046867ecaf41f899ca1e9e560490173083900a2c98b70e67413"
    sha256 cellar: :any,                 x86_64_linux:  "a7aa7d22e15a52f5581b1e00be8b96f4111a92a899bbb89baf0e4a406ff1ecba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
