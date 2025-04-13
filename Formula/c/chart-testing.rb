class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.12.0",
      revision: "d6991035017d7ac0e3dec3d1b5ad2e5f18674b32"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2138869a05cf42de24e10d8512bc26070ac19169d3bb41f061c226a67ac7aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2138869a05cf42de24e10d8512bc26070ac19169d3bb41f061c226a67ac7aaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2138869a05cf42de24e10d8512bc26070ac19169d3bb41f061c226a67ac7aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaaa3bcedb8fae176cd2ba889ebe715f11b3592ee61be0917c3ed8b232b4081e"
    sha256 cellar: :any_skip_relocation, ventura:       "aaaa3bcedb8fae176cd2ba889ebe715f11b3592ee61be0917c3ed8b232b4081e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2bea119cc70298682e2b83e5ab7df72f962ce06068a8548c4f643a77aea1ce"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test
  depends_on "yamale"

  conflicts_with "coreos-ct", because: "both install `ct` binaries"

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkg/config/config.go", "/usr/local/etc", etc
    ldflags = %W[
      -s -w
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
