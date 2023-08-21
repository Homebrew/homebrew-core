class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.17.0.tar.gz"
  sha256 "631ec9526eeb8335385ac02c6f02b2cf4bbc529faa82b467c27e723ca293b028"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470ceee60b728f0da54c1f6cbcde38a568d53e9fdec0b84d9ff95066bc2012b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ef2e25063e41255440a125745917c429e90ed138eb0108c25f3bb3df0ac96e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "403a652c4f3712bda862402598ef124686de6985f444707e5a3859a444049d39"
    sha256 cellar: :any_skip_relocation, ventura:        "e4d60f51ca00aa7c1dfe68e3c640c24f5b74bfec1be8ed0f564046455f899dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "8d3a117f798c41ba9881dafa44e9dfac0fd08598049489daaa4ec55e9ba00658"
    sha256 cellar: :any_skip_relocation, big_sur:        "696ebf3bf4643e45fc10e6834174537d397a66c4d1b5c85cdf40b8833fc48852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506bbf5da78147e47cf8db4dc6deda5db5b514ce02fecb30536ef7fdf8672104"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
