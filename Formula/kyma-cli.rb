class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.8.tar.gz"
  sha256 "eb4d3fe1877f025f240a322693e882b2c52cb6d87c9bf07ae9970536283aff58"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb4201b00d0b1adfb5bba0476fb0ec877374443f7fb3c14bbd9171b46ae1725e"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c6edc8e265844cc58a4fa57e7b41749d36856902b644fbab87da778644b32f1"
    sha256 cellar: :any_skip_relocation, catalina:      "ed22a06239355c824d04440bb7202d01056a8a4e0dfbcef5c54260248696ced4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630afd164c7bbcbef861051ef75c59380d8b80271e79fd1d7524249dd31293fa"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

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
