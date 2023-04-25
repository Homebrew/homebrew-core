class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.13.1.tar.gz"
  sha256 "70654f250e57996339f8b3627b4cd27529a1554131c19db8a90fead5dc2e870b"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a20226e0a03cf8d4db770c923fb88d294e8680558bb08b1b2684fe4aa6d8d4fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c77079db219cd74862492adfa5fcb1a6d258161f95f2d5fa902dd566b58c0c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2929a611b36746e41b04295f3b73594adb6ffbc9671625550eca6df4573fb96"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8453a951c7f268e9e05c3e49869eb2ff07cbe5fd971fcb877c1445b1abe57b"
    sha256 cellar: :any_skip_relocation, monterey:       "26fd8eca2455a150901832b13f77fc2f04ace1854450bedc625552a82b47bff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "98a5974f5292fbd1b93a41a43eff29ce30d4ab9f052513cbcbe37e6a006580ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b2efde1b1bb53216349c6cc84a5250d76afb7c6f6d66b80e55f36b024d41d1"
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
