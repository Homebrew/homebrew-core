class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.18.1.tar.gz"
  sha256 "73b733a0c87f5ad1573e34e1de77de67d5a9aae6bf860c0e4ab29f06a2e5b100"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678324eb4f800923aa48cd1dbeb21b1e092584140fb2d67c6b95173c4c26c34c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8bb6e995c969b0740f4a6c7392751b24466a4c4e87194fcabb950c557e1a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3069a3729ab1acef6e993ac7ae21cf3f9dc1134642d28573d091cc250649fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "591378f0e64db269de037804c4fd5888a4184dd0093f77b5259b55771d092707"
    sha256 cellar: :any_skip_relocation, monterey:       "7fea819b45a4e55bb68c5ed64d0b4a62ca7fdc770d552f84a804a6c4dcb2a8ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "1feaaf6ab0be1b40686c9d753e223ce5ec0afb32e164df596fcbdde671d2f4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01fde79a72113f9c2406f13dce85d859c0099368a736559eeab8462c003af408"
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
