class NelmAT1 < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  # Check stable version at https://github.com/werf/nelm/blob/main/trdl_channels.yaml
  url "https://github.com/werf/nelm/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "23d7af4dbd8e0a1f39e6e377008bc9f7f0a014c9351a1d0139ddbbaded22e752"
  license "Apache-2.0"

  # Track the stable channel of official Nelm binaries. This accounts for the
  # delay between a https://github.com/werf/nelm/blob/main/trdl_channels.yaml
  # update and successful release:trdl-publish workflow run.
  livecheck do
    url "https://tuf.nelm.sh/targets/channels/1/stable"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f837d613dde0b98db3285689b320c5cb9e42599a71ec484e92516623dc48d793"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53f8edd30d1303df52d762976e90009e90a132e5a58a315092a1710e8e8a20b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cadd15d9c85516144e699e7f523deef166fea0a7ddbb14a509f5de3455a6da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8929c66087cea3b7b549f9955d110efc6b09b7e17cf9d36221b4496ed1809062"
    sha256 cellar: :any,                 x86_64_linux:      "719ce16a0b6a4e94a20dda8643aad29c89bdaf10eb2662978cb9f17dd6322e76"
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
