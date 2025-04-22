class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "841dd2fdc5c194e1ea49f36204cce33a943285862303713a1baa5d2073cdb0d9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d29d64fafa1fd5d0ab3c05b16377049ec3aa96f3a585fc6d99337f021e85336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d29d64fafa1fd5d0ab3c05b16377049ec3aa96f3a585fc6d99337f021e85336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d29d64fafa1fd5d0ab3c05b16377049ec3aa96f3a585fc6d99337f021e85336"
    sha256 cellar: :any_skip_relocation, sonoma:        "11b0e1e99d27d8de32953e4ccf1e7f6220d8a9ee25627a5af787de3ba192b22e"
    sha256 cellar: :any_skip_relocation, ventura:       "11b0e1e99d27d8de32953e4ccf1e7f6220d8a9ee25627a5af787de3ba192b22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9c80cc6262219f16d293334fe91d258cfd4c43b98d746d1b6e4c311db7e895"
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
