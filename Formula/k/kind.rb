class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.20.0.tar.gz"
  sha256 "6795c3478a298973e010349b87740fa1732e18989856db0deed54b153330365c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ed88b06d26cb72da488a0f4c231c609aab34f17bd6ade695a36e155793ed54f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f2e8574b476dd2d7390de002bf8ff24c2135f83dd273cebd4e8a52c93d212db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2e8574b476dd2d7390de002bf8ff24c2135f83dd273cebd4e8a52c93d212db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f2e8574b476dd2d7390de002bf8ff24c2135f83dd273cebd4e8a52c93d212db"
    sha256 cellar: :any_skip_relocation, sonoma:         "fee9e210821734d857f03c2499e1eb77c30db1b28dbce8f8dba550bf67f21fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "c008b4119ddbf085efee3a446f9a882b5612bf833f8970ac7a91820c51737a82"
    sha256 cellar: :any_skip_relocation, monterey:       "c008b4119ddbf085efee3a446f9a882b5612bf833f8970ac7a91820c51737a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "c008b4119ddbf085efee3a446f9a882b5612bf833f8970ac7a91820c51737a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ca9034652e3b16335dc18f5262d9e6e2ecc29fa27207d12ec005a0b5b894b2"
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
