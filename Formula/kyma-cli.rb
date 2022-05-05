class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.2.0.tar.gz"
  sha256 "1c9eac608a1637732c3fae3492b8b4ec00a2a3d7c35a5572c80a9bd9ac8e09be"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89cfff09eb1e31bdb1cd2c717c0ffc04b9dedd40e79509f61fb009d8c00c9911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea5ee420ccb8508ea2360853e9015077d2829a7f246323b92e7d721ce1b12535"
    sha256 cellar: :any_skip_relocation, monterey:       "1f5aa6ab8748cadbd445fb1cd7978d6779a4140a01969c9702a582cd209207a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe96a70f05b83180014e3f46403e5d67a8ed34afca6f47e2853c74f38da5e16"
    sha256 cellar: :any_skip_relocation, catalina:       "8009d3f80d27131705482d76d8c30049c0cec3612b6fb256268ac9b207786233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc4d054d5e109c80637e83faa151eaa3af00f2d9de80a94b4922d4fd1f533e7"
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
