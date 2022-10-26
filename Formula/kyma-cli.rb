class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.8.1.tar.gz"
  sha256 "f78c5007ccc0831e72a3fa4f4774802fb0f2d345c2a1ec2f45470f490943de81"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b127abffe2ba6517541448da8c2220c63a98f1a85985b3dd714a06a61e009586"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4ccad74b483d2dcb6cf4a34e0f5b3633cdeeae063640075140d5e534e10d47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44e8cb0969e64cbfd434258210852c7acd7420345f191f365e9c23f64c89b13d"
    sha256 cellar: :any_skip_relocation, monterey:       "e83234de93e37f547f981124c7085111e13d10daeaf1048e6a43311fb4707e49"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a641acb185fff1a1c84a2e676e1dfe064f040bdd020256269efe7bedb3c98b2"
    sha256 cellar: :any_skip_relocation, catalina:       "a49ff898f0580130b51438c12d92ad732e8a80758085156e4f176fecdb616a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55778399b51cba2335fac44f85cc8d983337a5f5a0d0816b13e504200f356b69"
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
