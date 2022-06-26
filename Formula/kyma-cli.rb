class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.3.0.tar.gz"
  sha256 "a7bf6261fb474b79cad5f6dd2dc9d342310f2daef9038ab52054d6b196e768ab"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3857234258d1bd58766b94bbd990bd17f3ee1ed61db51ae7d5cdd7262fed0b80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce031a7d1b94170a85bde48919b15eacdff860701a5e12617c169e6421383808"
    sha256 cellar: :any_skip_relocation, monterey:       "42d575dbf70ce2351051d7c9d3be1008979ede62f130b1409adb2f9f9ec4fd0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c71020d61c1a0c1cc917c0a266327b64d86ada0306f8ed39036575a29a832e"
    sha256 cellar: :any_skip_relocation, catalina:       "b79e3905b54e9445c21bffcb28381e555acf2452935d2eb509096d21765f79ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a241e79ac0f111e28ea419e73632a636793c56a1e2d3b381f3b93113b7a42761"
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
