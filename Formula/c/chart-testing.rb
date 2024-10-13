class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.11.0",
      revision: "a2ecd82b650c223a8d264920fd0bab40de16b915"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "678136816f31c60ebce063934d63b363a502a62aa7b1678f9774473f0097bde7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7d5e565e18ee9f839bcf3c8720e696bc6f05f12a860fe8552da0953505df34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "401f42f076e103d75540474964ffe9d9641fed07e38e1d6ab27d86c7990389e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f69dd388b9c245d02b3ea5e6d8b1bc48dce4cd32a316fc77407e9a20f4b97ff9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fd111a55b46507cb12314e3d3da9628becaf2619c617a9983fcceb024bd8fa3"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7a5cca78ad8a0f9b91a5945a4fb0a39ea9896b1719153dcd945fe969194062"
    sha256 cellar: :any_skip_relocation, monterey:       "c5999b833a56149e1781bfda30c61cf6aa7cf64b4d617c4ba1b7e5e00321de9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390812d6f7fbf67ad8ac203163d02476db262fb65f5cc88b4df0492545639b3e"
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
