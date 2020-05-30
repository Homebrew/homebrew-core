class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.13.0",
      :revision => "4b943c861be35b5d563be4a5ebb6108752128c81"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e192169880d9eabd90c39d0d5a97d42aa10dcb976ec974737228ecb5fe085d52" => :catalina
    sha256 "5a82b30367d7cbed8d088115206bd4c8ecb1cb74b714534df30e9eae710d72e9" => :mojave
    sha256 "56a66cd9ec57d9be6a47c3b69ea87a6f734e7cdc27ea296b0b2f75da00e11a80" => :high_sierra
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
