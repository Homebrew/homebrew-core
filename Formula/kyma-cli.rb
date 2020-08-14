class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      tag:      "1.14.0",
      revision: "6e3d444dcfac01e8e45e419970f48cf122d26af2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3320550ade34f6c7d96515602b27030f8a6d6bb4a059eef30f2a98eb5331beeb" => :catalina
    sha256 "43059a73a68304cdba9956a4329ece0a749ae1bc219a8ed8e4302399c97bd56b" => :mojave
    sha256 "9bf1ba980a81a6788a689bdca5c7a605e42b6175ec283eb5b8947d074a15cce4" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    system "make", "build-darwin"
    bin.install "bin/kyma-darwin" => "kyma"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
