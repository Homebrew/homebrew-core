class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.11.1",
      :revision => "b83ddad043b1d08a43111e479b88c1f47ecfd6d0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f778165c45d49f372f4d78515eebd6e019900d65bd781b2611116d93adea41a" => :catalina
    sha256 "4f4e0b367ca17ef76bb401ed2df45dc55f7b05736d4c11031839e187e4ab6423" => :mojave
    sha256 "224d91dd7d59ffd517049966d4192c46696828876f1de1ead58426519c48bac1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-darwin"
    bin.install "bin/kyma-darwin" => "kyma"
  end

  test do
    assert_match "Kyma is a flexible and easy way to connect and extend enterprise applications",
      shell_output("#{bin}/kyma --help")

    assert_match "Kyma CLI version",
      shell_output("#{bin}/kyma version --client")

    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
