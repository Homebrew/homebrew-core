class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.19.0.tar.gz"
  sha256 "cc3bd320f484d2de3bef9a5d662d8727547f8a86034a78274a929b58f785da68"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b059d88340bd3ca3e64207ba7d880ff02726b4fcfec3cacf2fe7351af6a39217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b059d88340bd3ca3e64207ba7d880ff02726b4fcfec3cacf2fe7351af6a39217"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b059d88340bd3ca3e64207ba7d880ff02726b4fcfec3cacf2fe7351af6a39217"
    sha256 cellar: :any_skip_relocation, ventura:        "f5c4e816c7d937bdb7b4efb5bc273c55aba869dc12f904cf7cea56deff78d9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c4e816c7d937bdb7b4efb5bc273c55aba869dc12f904cf7cea56deff78d9a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5c4e816c7d937bdb7b4efb5bc273c55aba869dc12f904cf7cea56deff78d9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42924e632198aadd0ed22b20d0c8f7b6942ee15895ba0498c15b85b3c1b4ce50"
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
