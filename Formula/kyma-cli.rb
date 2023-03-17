class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.12.0.tar.gz"
  sha256 "86507fbe8b1b5183e007c6033225b3e05f52ebe5e974d35f0d1a4f7e585c77ea"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0325862eb0aaf69b6fd2576c8f2405a1a9361a3762e4126d31ef83e487c1dad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e43ea1a900a88722b066561fc453b611aee0fe2fbdb9b98de8dfe1e290bfa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4526cb89ead26753219271058e4800fd42ceac02db79893ac5a814484f8d3e8"
    sha256 cellar: :any_skip_relocation, ventura:        "f60abdf93fee6d3796b88051e7b6141b02539e8681a48fe52d78bc110be8064b"
    sha256 cellar: :any_skip_relocation, monterey:       "93f25b20e17843275ac9b035a7e55be760c1719cf03d5f9654ca555196328587"
    sha256 cellar: :any_skip_relocation, big_sur:        "444188b09dcc52d847a0803b441fde8539e86e4b515a821bc26f9a9de76881d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be76a7533e836a81c3af599b28f8e67854e6ea555ad8ad64e8dc337854eb1007"
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
