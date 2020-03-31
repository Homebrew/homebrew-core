class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.11.0",
      :revision => "08af0d4c94f0df496a409f966333e3706587a59f"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6db45421ca3ed01046a246b28b1a84da8dfaf9ba301c21af42f13855821d4d1" => :catalina
    sha256 "f781f98216ae26fe03183765f76ad8dd501511a45011571245d6a4d982500a7e" => :mojave
    sha256 "d2179d272381682d3c0f3b850b8a57da669f3c5d9b1b808b3569fb5dafa7f6a8" => :high_sierra
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
