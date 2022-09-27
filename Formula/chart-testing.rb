class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.7.1",
      revision: "f261a2809ace1dee3e597397c644082638786c64"
  license "Apache-2.0"
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed01a55334f607ded9102fed673d1eb0707fd2af11986256303476fe75915a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "521a1e22cff4db795be5ed5cb6e4e7186297ac0fe049b114ae99cb664a9d2e90"
    sha256 cellar: :any_skip_relocation, monterey:       "bf887df516ae0c29627071a240dcd0dc6c8f31bb75203e301447859e154f28a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9425b75ee14ab0f71905aea4047d5a3537d06349ac9b1da22312b615e6127c44"
    sha256 cellar: :any_skip_relocation, catalina:       "249097795cb28d76de44406e0cb8b8095958b0d0a2fb6e5a7931c42dc030a5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9f826832c910a120bf2232efbdb376207f351b5526a339333ab0c4a476fdab"
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
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false " \
                          "--validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
