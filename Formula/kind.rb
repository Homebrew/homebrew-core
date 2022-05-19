class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.14.0.tar.gz"
  sha256 "7850a3bb4c644622a1c643e63306ddcd76a5b729375df9bc97f87a82375b9439"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7b6b34dfd45ad097b5ad3b5001a2e135141bba2a34863b0edc7ba2f52b038e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6f5afdbd4bb2fa83f9b03ef8781f440529b60e18b937150aa852d5c240966e"
    sha256 cellar: :any_skip_relocation, monterey:       "41f08d541f68838b9eb5ad31a17db48e97224b6a36f45dae736a8c8a195a590e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cdd06d155b338767a66bb296ff81910fbaa3557cfc4cf43ed9a82053dc4a9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "674b16ed62f8ee9b7d330d88b2492e037968927d3a852e0f54a88984ec008df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e6cb05ccfb3d310f1c108af286f8323f7892a7c8faaec468634dca753b422d"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
