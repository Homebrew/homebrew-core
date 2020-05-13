class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.12.1",
      :revision => "65b772a0c8a9bd59564caa173f2e2477fcd4788b"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4917ebe7eccb7c5c07132b6ed5886cd5ec9c4d62ae9e5ee45ecdda1474fadcec" => :catalina
    sha256 "43c775043d8f535573a88dfc5281eb871430f8a1bc1b12bb6bf6d5db588c15e1" => :mojave
    sha256 "65b33a782f5dab8290978b45cda3a053d274993b87f4a2a6e8311b7b8a0385f2" => :high_sierra
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
