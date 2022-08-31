class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.6.1.tar.gz"
  sha256 "535035b946ee0f47d26f08157af951c2d2cdcbb65cfea0d13440e564bc41ad75"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2337afb7cd41ae97a9c83272b1d4bc9917fc2956f76b028d7f6b108473115ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb2a43f70a4a58f4b6377129149341a648b4d6217c8823a3e0c7b47fb80d0235"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a8692915623518bc2503a383bad5dbe132a3112be4d68b1b1aa60eb5c04c0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2482edd0ff4a36ba6649b9b8edfa803a5aa619f6e3c51fd0a1e7125421323bd"
    sha256 cellar: :any_skip_relocation, catalina:       "bfe867a74c00e8c7c93e5108033362a22ce439fc2de65b3449ec4def53814020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8def9efef4f5f60c01735ab1b81789bfcfb689b35ffb57ca8120d54a17d06735"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
