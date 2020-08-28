class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      tag:      "1.15.0",
      revision: "31ee12fdc214124aabb70be036d27e76ee8b9ad9"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7b1991137eb437e19ea6c762a229624ca059fdfbb1019aa73a6b79b40fd18c3" => :catalina
    sha256 "1e805ffd81b1ebd8ce6cdbb35070927eb43ee6ead2e18f94422374b7655fad39" => :mojave
    sha256 "7aaeb534aff89029902fbb8134cd71c99742c21a5360098771f51d2a8209a323" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    system "make", "build-darwin"
    bin.install "bin/kyma-darwin" => "kyma"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
