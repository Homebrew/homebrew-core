class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "37ad5552a26ad140fe634685aab738680d14c00c875be9717ab2cfc9ae6140cd"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5cda310befc24032b740692e64fdee80901276205f05ea47af34b68016b802e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba88c4268157e88f5d5181639ecb8f87ebc829a1d3dc166b3a88ebf7e57321a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a98a1ef3d4eefdf79de3e3d2b79ee45ad3d8f0df2850fcca9562f7da1b7f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "888a0307e9c2aa4410c77feb5010dc3b0794e36fa6d2c1852ea156ec277caf44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e34e558b2f2c2b65b0ed00160972442f6f9c1ff87bb5b17ca2f3cf109715932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e678b08cc50bb5bd86deb10063773fac7cc028840b2a26332e71c392191a5d5a"
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
