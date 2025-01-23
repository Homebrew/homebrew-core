class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "14f88cd42b6e53eab800c157179b45fd65922fe3c91cc886da8e14f06156a09b"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49eb0e96e1b88654bb90dd79ad2441f1cef46d092373416f25c2dbba69343258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49eb0e96e1b88654bb90dd79ad2441f1cef46d092373416f25c2dbba69343258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49eb0e96e1b88654bb90dd79ad2441f1cef46d092373416f25c2dbba69343258"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ae17a83113ab9419581dcea555d30a57f59352d841fb1073d39500a77df824"
    sha256 cellar: :any_skip_relocation, ventura:       "c4ae17a83113ab9419581dcea555d30a57f59352d841fb1073d39500a77df824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7bc23af4949a8b336e04a090036fc85936477818e18f6bf52337d947cb04206"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
