class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.18.0.tar.gz"
  sha256 "91c89607688d36218a10233eecd769d6dc81ee36ee97b305d7f91c9109af5a4a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e69152a1b3d0334ef2c7db7edb9372666aa1c654696c0bb12af3b998b9e7bbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e69152a1b3d0334ef2c7db7edb9372666aa1c654696c0bb12af3b998b9e7bbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e69152a1b3d0334ef2c7db7edb9372666aa1c654696c0bb12af3b998b9e7bbc"
    sha256 cellar: :any_skip_relocation, ventura:        "9dcea9b6e7a434bec192cd288ef757183f5433f4a8328154c5b3b33f04e11f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "9dcea9b6e7a434bec192cd288ef757183f5433f4a8328154c5b3b33f04e11f5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dcea9b6e7a434bec192cd288ef757183f5433f4a8328154c5b3b33f04e11f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f031cff7b35fef93215d95b977f48e33ba6ab2694c6ff5820c1227661a0ed37"
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
