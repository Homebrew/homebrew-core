class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "6b0ae7748144034ba296a302f5aaaad7120aef4df9d8138cc6276a43ca3c96d1"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472a0a175ae63c92c8975fc202905dad51e248b4f398eed975df307f0bd14c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472a0a175ae63c92c8975fc202905dad51e248b4f398eed975df307f0bd14c5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "472a0a175ae63c92c8975fc202905dad51e248b4f398eed975df307f0bd14c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d874230e058d14a3110ed5ea57f60402c22899ba2ae52f6966740e3530f2ee"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d874230e058d14a3110ed5ea57f60402c22899ba2ae52f6966740e3530f2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f648c44eceb2862a2bfbf1cfeeb2e617af65fff6b493739e0506c7417eaeb2a1"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
