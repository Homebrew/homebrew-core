class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "cd68aad8c1f62f05bce06416e928c2922b76b608bd8af8311f518e2941acfd76"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795369e861c4fd5cad6c14bcb2aefff51654cce635abf17daf52cbc60c0c7110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "795369e861c4fd5cad6c14bcb2aefff51654cce635abf17daf52cbc60c0c7110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "795369e861c4fd5cad6c14bcb2aefff51654cce635abf17daf52cbc60c0c7110"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7ebb36f732a599e5fa3f41e6dcb2d3ba0d35b654524f54276bd2ef885d6739"
    sha256 cellar: :any_skip_relocation, ventura:       "ce7ebb36f732a599e5fa3f41e6dcb2d3ba0d35b654524f54276bd2ef885d6739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a29ee32f9a398c5bfcb5aa8b38d24caae5015ff722fdfa712b6bbaefc21bfbc"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
