class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.21.1.tar.gz"
  sha256 "f5177b73aa49dc28e14fc47ec1fb654a1dd5da41ea0676d11a35983a17e0e2e3"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7adc5627d7e1e0e1c6345aa333220aea8d01404ee5c9e5de86056fe8f44180aa"
    sha256 cellar: :any_skip_relocation, catalina: "e24ce15e8a8952bccb09e95296611300c2ccdabe3bf840c7d6e1f0f4859f085b"
    sha256 cellar: :any_skip_relocation, mojave:   "571e5fa55baf08581a01e9f2fde9769e72c7acfa70baa7a0459a552b2dcfa6a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
