class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.16.0.tar.gz"
  sha256 "28b85260e326dc6b5baab28b927dcbf73f4f48c276364310ea0a7c9bd5e69f51"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba4adb90a05a80d01d7fe3ce06f186d711340febe4ef9b118ccd08c0a34e1db2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4111c08fc3b492efea9f03ea4b7bc482b9ba8a967ac2817f7f81c409498dfa1e"
    sha256 cellar: :any_skip_relocation, monterey:       "c07f914307fb815393edc11f22b468b4862251407a52a815e58e6e6f342e0d36"
    sha256 cellar: :any_skip_relocation, big_sur:        "313221bfc5740c608c9ce100d4d48eb10f3f5b7325bf6c408596fc4578943c75"
    sha256 cellar: :any_skip_relocation, catalina:       "7537dd70af562b23c04eed9c4f129fa6d19deb12913f4ac6a913a696c1573f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677fe6d799f5fa9efec2b89cde38e01722fdbfa8d06bdd0f90e2c83c270a1cdb"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"kind", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
