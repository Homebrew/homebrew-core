class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.17.1.tar.gz"
  sha256 "f29b896396bc9a009712dfc2c0888230510db5add5c76e19e9d258ed10df6b83"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a4008660d3ecbc54480736ac6db51fc23dbff7fb7cdbbe2d7112704d007a78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf80004998b2ee015baaf14895bcc1b6b02c096894bb145edffb957a9f9ef9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4859ddc53f01a92a14f8f4551dcf3104d4c0b4a42e3cb27ab14f4d1eaeca0086"
    sha256 cellar: :any_skip_relocation, ventura:        "fd50a68d49645e3d3d7cb7b5fc94a49ed06b21d407b3ba40f1227057ea56ba21"
    sha256 cellar: :any_skip_relocation, monterey:       "851616609e46e874d2f81beab1e283392deda18d7bf6ca0c35df6abf99416e36"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad1ffc2800f0ed5f9978843bb30b788e55aeda5516d18bf4bb1235b2d10d56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bef8a4b44771d8e1ee127910a8afd28ccb2efa04e26abee6b8de59d05d2ec71"
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
