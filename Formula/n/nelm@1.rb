class NelmAT1 < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  # Check stable version at https://github.com/werf/nelm/blob/main/trdl_channels.yaml
  url "https://github.com/werf/nelm/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "67c5e9ac812a66c82fbd3f7293e287cf837967791ebcfb4579420873bae8910e"
  license "Apache-2.0"

  # Track the stable channel of official Nelm binaries. This accounts for the
  # delay between a https://github.com/werf/nelm/blob/main/trdl_channels.yaml
  # update and successful release:trdl-publish workflow run.
  livecheck do
    url "https://tuf.nelm.sh/targets/channels/1/stable"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae5eb227286911d5e949f1e94ee78360838f985b9b44c1b0837d63cb38cf2a47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dc31cfb79f8d7aca8040176ab230a4cbe71d37d0212ee7054ef7c748d5678f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "854be436292d037848314dcd3c38235af901b814cd94e351ca6df0c6c1f177b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7a75b9c985d58b4dcea384ba434b3b5272cf5428222c76413485d5058f2b92ef"
    sha256 cellar: :any,                 x86_64_linux:      "0361eddcae4695f4a19e8709c8a84acb51d14684a486fc4b188b415d86229f48"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/werf/nelm/pkg/common.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"nelm"), "./cmd/nelm"

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
