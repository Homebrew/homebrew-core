class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.9.0.tar.gz"
  sha256 "49d71769565e325711209653bead8e1eea2a8e4f84cb0ce2075229bb2e2f1441"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba7d2cce282a5f8072b7657d1388e4bdc33d7def98e9218bf9abea232b5d2af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ae643c25503e815ce9e319b88be82b58c5b0e283837fc5a9b3628f5da259a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b46bedd51d7543ab581a0d16573d728882b5aef92a165753d99b5dc39c720546"
    sha256 cellar: :any_skip_relocation, ventura:        "9792bf10f1308a6dd86537960c4a8d6efeded9b6e7e408c3660bf2474c4e785d"
    sha256 cellar: :any_skip_relocation, monterey:       "568db6394f2b7835b96f0f1a50927e4662794c7835eb1234eaf66b22da411db4"
    sha256 cellar: :any_skip_relocation, big_sur:        "137bd2e454cbf76744b0e2e2b4c80724b2632d3b43fbeff3e2ef7ab252ff7391"
    sha256 cellar: :any_skip_relocation, catalina:       "07c332b4ffe684bacbe442bd9e507adf6f950747831add86acd55ee040a8e33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ea30e8c40796294a7e5b0053ddc6e0e3518201a76b1a63edce367ce805cc54e"
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
