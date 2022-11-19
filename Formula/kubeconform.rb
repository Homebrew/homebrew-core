class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.5.0.tar.gz"
  sha256 "c93d091a4abf3ea5245a281a0b7d977833c361af0840cd6cc5c2a638b98f1f9e"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77e0e0130ca33ff8b8d612ddb8f33ccbb682fa4e96444f277a40ba1bd8891138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9ff374d9b81312bfb4f3ef747cd199dea68b30d0f9936a6355f70735c9141c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f89943724bf63b9312f728cca4bbfb7911043e38751b5d601d65d2cf41bc295a"
    sha256 cellar: :any_skip_relocation, ventura:        "e0e96b27bed26729c644c31e908372147e969c776f3b792d57d8a536a7338b84"
    sha256 cellar: :any_skip_relocation, monterey:       "877d92203a7ca17ef46bc34d1d83da53c83a8374147b8917332dae28c2814507"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e4b9b605518b3f746217ed3a8079ca9f2e2d9cd7011d8e08fd173dae269faa4"
    sha256 cellar: :any_skip_relocation, catalina:       "097d1fe5597804e13fe037f855cc1d703e473836b5bf8afbf1a8a7ac8ccc259f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d46b781aaeedd609a381c2ee8d621541188801fd09f9d2cd13d94f7bd374b8"
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
