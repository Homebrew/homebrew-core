class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.10.0",
      :revision => "c0ed9588f020e897a0838eb51741ab4960bc3f74"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b46e17d23009cc8eb0fb2bb2a4aaae7b85cde198a42a6f114630b4386d227c1" => :catalina
    sha256 "24161d304dabe8646757257800d9f5cf34e660716fccb0ee21edd303bc0d627d" => :mojave
    sha256 "0ad76baeab2ab4cb19ed6c76431542125d8c10f1f1f2d481998a8eb7d2201598" => :high_sierra
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
