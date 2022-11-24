class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.9.0.tar.gz"
  sha256 "49d71769565e325711209653bead8e1eea2a8e4f84cb0ce2075229bb2e2f1441"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecb8b57695e22d5fef1529e1a40f2626f46705af6c1186034d165fea4f7cb730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4979be0b6997b2abb0813f3f45338f44c2c7505b2af7d645b9d9f5109acba682"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d0136524adcf0c38f0d73c0ca24f7eb509940b80335d229830c2b0e7b3dd286"
    sha256 cellar: :any_skip_relocation, ventura:        "6c51074375fb60aeb62dd5f4a869c0ac3320e48fa17ade7a00a573c97d7f96a6"
    sha256 cellar: :any_skip_relocation, monterey:       "7800230afca74f02a30beab989c61d070fd893706d8123c26a80543667e59a55"
    sha256 cellar: :any_skip_relocation, big_sur:        "d206c2e01f136ce11e61fda14607c151f993a193e1d4014f61d67fce2df5dc81"
    sha256 cellar: :any_skip_relocation, catalina:       "88f8a87f8233b23a1a617773d6db4f227751a0a1f3aad04385ea1e1c85fa78e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d261c3bcdb6c2e5501fca55f3c2db885c58c7937b2716fb3194f6d8f4c3190"
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
