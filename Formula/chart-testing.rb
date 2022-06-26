class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.6.0",
      revision: "49167c48fd3180c183290f5be178f7aa28ff1c49"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cd2a960c4644ac5ad2bb144a62a18647e2870a06ea3fca098678516cfd40138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f368c20c49acebf8da3d4dab0172f8eb4d30d9a7015c2f364dd3b9dc74ccfe8c"
    sha256 cellar: :any_skip_relocation, monterey:       "ff34fe86e7dc85d95374e060ecb6ce32c6a064f8e889cba5cbf1b55c0a7a284a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8dbde1207e2eb206e69555d55afb07202c666d90fef50699e758d3fb72d2f31"
    sha256 cellar: :any_skip_relocation, catalina:       "7953cdb033a650426204408d8d52e702104911b2ce15a7a3b57d92b53b736695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c880d6bc8971f046d406c70ee4139c29497a7e984fb61304939fdf6b8dd399c1"
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test
  depends_on "yamale"

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkg/config/config.go", "/usr/local/etc", etc
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{Utils.git_head}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{time.strftime("%F")}
    ]
    system "go", "build", *std_go_args(output: bin/"ct", ldflags: ldflags), "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match(/Version:\s+#{version}/, shell_output("#{bin}/ct version"))

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
