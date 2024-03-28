class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.10.1",
      revision: "c35d32b568ba7901e00d3386a231ae2b6e1c2efc"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f23cf4be74376a370643a356da42b59a0b7873681a13fe2da14e7a260a1800c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6af97f4df046f046c362dfc3b9ac61f513472cec24530651815da48d5868a634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae70ede98aaf37748920fcfb03bdac35dad9c70060ba3e555731c27cd45a6325"
    sha256 cellar: :any_skip_relocation, sonoma:         "7075be342a3fa23cba24c6da6a66536f893b7968f946f4957370bcaf9b89a517"
    sha256 cellar: :any_skip_relocation, ventura:        "910486d105ab59ae8593a7a2468de9fe51035a32db745c03d930963a1637632b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a228b000b856bc3e7d329f86802e6f0008b73b8f086ca6e0a50e3585f23f89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ecbef11cd37836c2ec07d2b9d41a51b51ba7e81953f4af22f8210e820dd3a4"
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
    system "go", "build", *std_go_args(output: bin/"ct", ldflags:), "./ct/main.go"
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
