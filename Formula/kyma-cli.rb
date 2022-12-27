class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.9.3.tar.gz"
  sha256 "f7bd2dfa2943343447422b30afc4ea051f897fee29de33b7e227d675117bcf5e"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15370790ee0ceff44c794b311a3046c4f2937b702bf6c00f0e1a133d3832a8b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecdcd7cec8ca9cb1f5f7db387c9b40fc357e915e080e35f06fc5d072be7a1757"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68759602e204d1923dd235f4a3b6a565b5b7f920d82c1b12907dfe773738f7ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd47a0d4a6edac827197364122e0a7a2bb9215ad473773588dc0735fa3a5be2"
    sha256 cellar: :any_skip_relocation, monterey:       "a700e2d1c88b63e5caa9a4f97bd69ca2f056c590969ebbef1402d9cc77a6d163"
    sha256 cellar: :any_skip_relocation, big_sur:        "5726ddff03118f74628da945b3eff4825e4bbc1619b47527c75b2a24aa20a108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529fb369a6047e4867203da258ffe81533215be6fe36cbd809c76e1ca912efc5"
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
