class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "bfaa702786beae1a9958d4d9cdddbdcc94c8ca5f7a5dca3a4a5a748c51477693"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167388c6fd980b35106c005c175d0a57e14492fc82ed6f4b11c0feb324939139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167388c6fd980b35106c005c175d0a57e14492fc82ed6f4b11c0feb324939139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167388c6fd980b35106c005c175d0a57e14492fc82ed6f4b11c0feb324939139"
    sha256 cellar: :any_skip_relocation, sonoma:        "799bf8bfeb9df6c9fdbe780dac405d3a7657e7a108391d303dd5516e50b456ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c86e8a9260b02f4064bce4d29a1653713e3beb22bb4f5ea7d037798a5d5fc08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34d6b4b376257667a82e16befd9e264baf7c9b0248b9f1249609311c60ffb0f"
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
    assert_match "failed to connect to the docker API", status_output
  end
end
