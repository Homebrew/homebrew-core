class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      tag:      "1.14.0",
      revision: "6e3d444dcfac01e8e45e419970f48cf122d26af2"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "759f2b51bdbcc2120aebbe5c317cc9fa55b5d6e31021cef88dc5a2195a71ea57" => :catalina
    sha256 "6b4e10ad5a3a338306cba628a1cd5cc559cada670e60b7df697568606a531296" => :mojave
    sha256 "bdba95466c764d98b4af185b82da1348c9ae656f167ec1ca30ab285eb4c75801" => :high_sierra
  end

  depends_on "go" => :build

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
