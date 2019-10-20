class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.6.0",
      :revision => "1471ec088d7831cd3f461ec4ce710f19b85903c3"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96b57388a6328157114c8c14e7d3291668f175f471ff957a4a9a6d69599a6a03" => :catalina
    sha256 "7be49d03b5e679073fd2c962003178d32a763497f806c5de90195e986d1aaacf" => :mojave
    sha256 "58723114b1043e44686c6d07bdc241bb1bcd2f1f6e85317017b480acedc52800" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/kyma-project/cli/"
    bin_path.install Dir["*"]

    cd bin_path do
      system "dep", "ensure", "-vendor-only"
      system "make", "build-darwin"
      bin.install "bin/kyma-darwin" => "kyma"
    end
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
