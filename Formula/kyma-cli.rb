class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.5.0",
      :revision => "6c8148df282e0bd23a377e9e5eb250c33179a1ca"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4f0222bc6915b6a4c73f6565bbc560bec671bd40b420d7fe0934c64e5734e16" => :catalina
    sha256 "5a8705b6de2acbaa0a6ba66f0af112c6982c9618d006c5a3012298e691e58043" => :mojave
    sha256 "b3a2fb78d3f063057712823f1bcaef51cdf38606b8b83cb506508e8134017c31" => :high_sierra
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
    assert_match "Kyma CLI allows you to install and manage Kyma.", output

    output = shell_output("#{bin}/kyma version --client")
    assert_match "Kyma CLI version", output

    touch testpath/"kubeconfig"
    output = shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
    assert_match "invalid configuration", output
  end
end
