class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.12.0.tar.gz"
  sha256 "86507fbe8b1b5183e007c6033225b3e05f52ebe5e974d35f0d1a4f7e585c77ea"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a99c103293abd0ef9e35bc2ac50d609f1fbbf7801970a4fba9d74717bfde588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697532b8de5febe99b47abc783053e0f7df31e944ee95d2f9ff2a8993170d61c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af38205b0bba245a52cc3db94192b4467a9e93c0985c59a3ece3e0a8e9bb1218"
    sha256 cellar: :any_skip_relocation, ventura:        "47dc14cdf21ceedb8c1633848a9d6e0400205bdf5ae396d7b89e9ec045f4069d"
    sha256 cellar: :any_skip_relocation, monterey:       "61cf576c37a4e8b9ea53d9e0dec785cc2f3ef9ea6cb941f9fc9639bbf6259da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac4e78548460e582e7922fdb5b8e59da5229025dee0635afaf361bdbf75cbadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6138ce1d4592c3e318da2dab1bd6a1f14107100dd2d1e709f7476265d456f0"
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
