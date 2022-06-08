class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.3.0.tar.gz"
  sha256 "a7bf6261fb474b79cad5f6dd2dc9d342310f2daef9038ab52054d6b196e768ab"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50682bf020bde3b347078e9ac86e011fd08daf9c3a82c26823dd668d7564c06c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7254d847e1eb52fb820b75293b1ca0709a5b613184e0445c0937ad6f8916ecc3"
    sha256 cellar: :any_skip_relocation, monterey:       "8de23a0097e841b1e5e53f8f5c61b75ed20f367cbfec7770202a6603db53d856"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bc0a38417c2b8ce1c9fe8b265a813653ff3cd1a89ef3ffc8a7c99ee9986ab6e"
    sha256 cellar: :any_skip_relocation, catalina:       "88937710e86db07534a1efb265b4c956ef0c3f62081138c0e15a89322e42c230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90a10c9cd505c2aa427ef40d99d1f0f6f07c2ab4af796e4a86778b29f571e5a"
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
