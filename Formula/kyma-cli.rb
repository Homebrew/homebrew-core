class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.12.0",
      :revision => "11279bcccb63490935fb074ad326a90452e061d6"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7acf496e7cd150936a9f90324f080c01c8e4d93434e7c7304cf0ce1e042cf088" => :catalina
    sha256 "686006e04837f0a776517d14f35939cc3176dff2040e625f116c0deab0c0c082" => :mojave
    sha256 "67fbd741876cdb523d4e4ecaaa6964d63bc9d54f67f09b82bd3791bf3ad39f4c" => :high_sierra
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
