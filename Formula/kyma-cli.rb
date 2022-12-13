class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.9.2.tar.gz"
  sha256 "f88b6160bc2ea08ea1fecd29c8cb5fedafa5007ed02370e1b65ace0655b2a0cb"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2b01c40e60e22032cb64bcc498d4e1520c186b133f851218a0983440cf10f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c90a8462460c3105737edc70c5e3c0aa7419dd276e40457a9170eec686ed7e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52120c873dac61e94d9980b221a99dbe0083d593ce4dddf36a77755b9ff9d87b"
    sha256 cellar: :any_skip_relocation, ventura:        "3ecacb6e186b1e912597515c0bb63a0f644914ac6c7bfcc96310bbd0def1c932"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb6562e71d98dfabc3991589511f794619245bb19a0525869ee0b308c2d98cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "706b8ef4da725900d8f38d8161ab9c53dac39d83c787eb478b8e2bf3643bd58d"
    sha256 cellar: :any_skip_relocation, catalina:       "236aeca9bd57ba2a4a800ce0a3410663b0e5902dc2ebc5d4b272998e93bcf9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ed0e15fa8c7749a85f90fc2d685b68290f75b1e383e7b3c376e1c9a467492d"
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
