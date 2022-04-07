class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.1.2.tar.gz"
  sha256 "a8863522d15685994a1cd7dfaad349f7c422c93a1a52d3ca6f5327dc34b26657"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4301ac37f1a23d5628e45ca2892644ef18f543945025e7571b2e17914301b0e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e528ac222e349752c718f8d89d26b32e59826b840ac990f0026e061936a7d8e3"
    sha256 cellar: :any_skip_relocation, monterey:       "51ad9ca054e625430e5fe192a63651fdc15a92eff8dde6f99497dc7af74ae8a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d9c06108d277fc54a2f7f43d0d4c52193f44690be39241f1d2e114660eb88e"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d54e8294e4009d068be27e791b4b09b189e874bd4c0e9a4a15dda66d3ebea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feefb80fcbdef3d0d7d8e9ec077f84a4c21e5d869cb25c4d41d63e8d3d899b73"
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
