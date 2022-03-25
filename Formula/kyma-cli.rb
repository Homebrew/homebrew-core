class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.1.0.tar.gz"
  sha256 "70356bc4cb85ccaa66ab93b8eb5691c8f647a9fc85427bf1d076d867c5d150ab"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d717d559a6677442c1eaf0fd18b44699f993db5ed6b4639e274bd8885ef58f64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "579b38753983943fdcf4f8765a2f7d5a0ff417da3039212b225d5bf27d5cd124"
    sha256 cellar: :any_skip_relocation, monterey:       "714e4b2798acf529bfde1a623aa10538458430ead6d77893a43e8150de641795"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f6dca4fe702ba32fb99160be739cada931af146c496c89be0a65e7b36a237c"
    sha256 cellar: :any_skip_relocation, catalina:       "5c0d06e2f5a30d58caaff7aa41cf460b2c1edc8e2f2d628d9dad2102084870ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3658d38f903035677d5da78289bcfa6db9f0eebe8a6dafcbacb884b79151d355"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
