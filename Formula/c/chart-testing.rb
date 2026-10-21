class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.15.0",
      revision: "c65afcebd6649d48179fc8b30db34fa9b1459cce"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b93e26f8d7b204fbe9df598dfb786e8a8180071ca1790566fc6e9271dd33bdc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b93e26f8d7b204fbe9df598dfb786e8a8180071ca1790566fc6e9271dd33bdc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b93e26f8d7b204fbe9df598dfb786e8a8180071ca1790566fc6e9271dd33bdc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02e58a5224634b08f22405a15c0d814af02877fa3ae42eb45992a5f39e29066a"
    sha256 cellar: :any,                 x86_64_linux:      "7f4cc7ac78d260193a07c7ba36d1b2ef056ed7092803683c22bc8b29af22f513"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test
  depends_on "yamale"

  conflicts_with "coreos-ct", because: "both install `ct` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkg/config/config.go", "/usr/local/etc", etc
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{Utils.git_head}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{time.strftime("%F")}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ct"), "./ct"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match(/Version:\s+#{version}/, shell_output("#{bin}/ct version"))

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false " \
                          "--validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
