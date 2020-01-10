class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.9.0",
      :revision => "0fd63730643d6bd1abb5e50374000740d1721772"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eaf207c14e97c39fffdcad41701c7d38670248e6104208db3c78e4eff8c06c09" => :catalina
    sha256 "bf3a28ea32655812abb2840c50242220cee249c020db4d0f79ad342b53f73b62" => :mojave
    sha256 "a8ec9a335867521d07b348928548d41b7627631c48cc1f14cd4ba09004398db6" => :high_sierra
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
