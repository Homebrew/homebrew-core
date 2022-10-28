class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.8.1.tar.gz"
  sha256 "f78c5007ccc0831e72a3fa4f4774802fb0f2d345c2a1ec2f45470f490943de81"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfae29950714163878040c3375452006138b16cde1e909e8971a02cd602ed393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15b1f9f9a67ff2d65f9c500474f2f2db0caad36ae0393920aff3b004645a9158"
    sha256 cellar: :any_skip_relocation, monterey:       "7f93ca4364c3bcd0ecbd27c58650972d51b7752f708d734a643151238244c93e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a2a305d7728a35e9f7fecbe489e3299b289414b35d3d9edb28f042a1815f4ed"
    sha256 cellar: :any_skip_relocation, catalina:       "bfefc9843010170e2f4e5ef017e65c61e72f303a300d3d2ca60f03ae06b768b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf1e089663e36cdcdf301206f493b611ea837a942d856c6ac4784ee5d127405"
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
