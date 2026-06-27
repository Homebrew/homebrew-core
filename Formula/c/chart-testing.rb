class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.14.0",
      revision: "2651b49048950c5473b1f533c900d17614bc6aa0"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1df796ab13d24fd7f6a786393a10807fd0e783d4b47ab4a4e9de1c11ded7245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1df796ab13d24fd7f6a786393a10807fd0e783d4b47ab4a4e9de1c11ded7245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1df796ab13d24fd7f6a786393a10807fd0e783d4b47ab4a4e9de1c11ded7245"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e6618ea266830c8b9968f7e6b6ac17ee3490210627753528cc46389aa2a4a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c94595c95d8aa4d96cfce81c4baa6d018e3a6ffba221de525cdd31d1b43f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc6e33ee4183e77342abc7a8ce58eb172d8ca344f12c833adef315f01b5fcad"
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
