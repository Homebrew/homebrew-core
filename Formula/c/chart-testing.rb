class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.13.0",
      revision: "dac2d60e7a47c929a9c1ef545b83ac247d9f51d8"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0faf3efe0f5c189917186de7e840c09d8d404789daf212ca9229addb67319ceb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0faf3efe0f5c189917186de7e840c09d8d404789daf212ca9229addb67319ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0faf3efe0f5c189917186de7e840c09d8d404789daf212ca9229addb67319ceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "efeea231950969e1e64dca249476d63b1732b7eaf607f4e01e2e7fefe868b537"
    sha256 cellar: :any_skip_relocation, ventura:       "efeea231950969e1e64dca249476d63b1732b7eaf607f4e01e2e7fefe868b537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "519215363721042661fd326ffc7e1a31af634518fa4df3b13f37cc8d08079653"
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
