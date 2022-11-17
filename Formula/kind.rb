class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.17.0.tar.gz"
  sha256 "056171a47e6fa0e7f52d009dd52bdeac30c517566921807f83b3f6ce47fe3be4"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1d3e59049dfd7a6ab5e8ef7baf6ccd9f93dd3bd5492a80e560a16d338e1d340"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af67631ffd2e24b85a73435b216f32cc5e3906e81b075d2a54946b56ac579d91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19503a9164ee7c76337818c5d8e6fd96c961db7a7e6b8af4b8ed05b0d8208cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "de12182aba6efb376d26c3bcfb42763004d03378db8f4473a5ecf33c17e16a67"
    sha256 cellar: :any_skip_relocation, monterey:       "f91bf1e4ff9baf086f7f0f851e93cf9dbbb24361f38e26572bb889daaee0378f"
    sha256 cellar: :any_skip_relocation, big_sur:        "20675a8cfd76846dd9d17ee88f4ac522eb5d145cde782f9a952e096b9a921c74"
    sha256 cellar: :any_skip_relocation, catalina:       "d66b9a9eb2a952af2c7782ae545dc4917a2f20bada059aa1200a50126c36c1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67799fa122f7044f4501e50da12d83b27016e43a26c5ee77c516931d1ab754d7"
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
