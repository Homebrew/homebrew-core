class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.8.0",
      :revision => "89fdc6dcd8c39e0d8e15fa63d6cbee02b9638b17"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c762e252ca9fac83aace4a9c64ccd697649aedb2b5316b1b4262db0512ed370" => :catalina
    sha256 "ac947921edd96aaee0316200b9d89b000134095f7dbe67e1bb58662548ada90c" => :mojave
    sha256 "fb93cc1699da81e9927e5664703a29af043c23693300790b3c09e69cfd7a4562" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-darwin"
    bin.install "bin/kyma-darwin" => "kyma"
  end

  test do
    output = shell_output("#{bin}/kyma --help")
    assert_match "Kyma is a flexible and easy way to connect and extend enterprise applications in a cloud-native world.", output

    output = shell_output("#{bin}/kyma version --client")
    assert_match "Kyma CLI version", output

    touch testpath/"kubeconfig"
    output = shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
    assert_match "invalid configuration", output
  end
end
