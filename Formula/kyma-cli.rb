class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.7.1.tar.gz"
  sha256 "00a1fbdeb6cc258813f456adc6bd7b3b7c3c98eae348849c19911a83be9ccad0"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f5ca88de6b761ea93148150a79ac122ee629b33ad797fea9b414d4a1010124"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5d3b8c676cd2a31eb5cf607a14306243f5f19266f3522eff4535d4610cf0b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "2abc5d25bd1f4d205da1c182e6d8419190e69dddc545540b5ed94ee7aba5d256"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4d92bff1364fea0594a1a1b5ca8ae63ce5382d331eef12cd2165a045778c9d"
    sha256 cellar: :any_skip_relocation, catalina:       "de0228f959995e64b501b00c9ee061e4798194f4996009df470f70300c4e7480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70dfab0a69e0a355cdc80af9105d529a2d271a7098a1f7131a32757d56615ca3"
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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
