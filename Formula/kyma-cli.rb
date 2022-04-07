class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.1.2.tar.gz"
  sha256 "a8863522d15685994a1cd7dfaad349f7c422c93a1a52d3ca6f5327dc34b26657"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21fb409ca35e07a84176c73182f5653aca01e4b39e788be4638c21942138e1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed2977c1c870097f8f499a65a4fa6a0c2c95d786304006e7913fb95375182327"
    sha256 cellar: :any_skip_relocation, monterey:       "4086f538b4e855f263d8b1db270da08e2fb3980e62d89ae7a8ab965ffa6721d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fe515907cf8899812ee3e64728835cae24d698cbcb5d57cf62fce80cf24d2ad"
    sha256 cellar: :any_skip_relocation, catalina:       "94b50895b2242470f7a9ea48f05d6df67211559168cf7706199bb1f0f3028c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93900f8e1be2139635972ce8ffa0671757f72a0d3c3a1dcebd2aebe778762b24"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

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
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
