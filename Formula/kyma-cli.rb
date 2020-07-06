class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.13.0",
      :revision => "4b943c861be35b5d563be4a5ebb6108752128c81"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31250ef53da7d2d54659867bbb41122a8aced78fbdf7afac97a7cdbc755e2232" => :catalina
    sha256 "75b428267bd96bece87a36e4d57b5915406ea5669a825b5d2c7d31d460de58dd" => :mojave
    sha256 "bd8d44c4b6ea8f2ca516e795e33ece1a399cf93ab078902e24ac969494a5230e" => :high_sierra
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
