class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "1.7.0",
      :revision => "0e34ef7f27acabce43c3ebdbcf57534ed07fd46c"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5d358b2ed496b15372fbb3a8d55fe9fd098dca993fa07010dcac813c2d41c54" => :catalina
    sha256 "654166e59fdb3267fcf30d324498816f9288729b816cb608b9be8491399df166" => :mojave
    sha256 "9ed07aec0b30388db0998f6298b1dc9add7772c9d391e755e719e3ee1eaa5866" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/kyma-project/cli/"
    bin_path.install Dir["*"]

    cd bin_path do
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
