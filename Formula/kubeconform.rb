class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.4.13.tar.gz"
  sha256 "e6d161de050afa205454fd4660c465e35632ba6ee209a3481baacf410f250688"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74dd1d995e736daa504ef1368e4f7a4ba541c944cb8e3b476dbda52d36e08595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa049949d32864521c74edd74c9d375d3e2eb4858014bfbb7ea0a9fadb777f78"
    sha256 cellar: :any_skip_relocation, monterey:       "78a8ab92ad7fda829a09aa68c4fa1414a59c18bfe2f33f22ab2557c17a45b6fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e542f30ed6a67d429ed2747252e7de8bb2b0d4ea7fa1be2221c8559c84acec7"
    sha256 cellar: :any_skip_relocation, catalina:       "fad2ce7e4674c30adef19bdb85c77010c2eb6d0f6b897c98b2fd6d45448b2d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cdb8becf0620eb5cb8b1dc1e7caaaf06183047c61ba97bb430057af4077ab7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
