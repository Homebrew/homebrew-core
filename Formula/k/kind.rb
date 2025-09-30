class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "bfaa702786beae1a9958d4d9cdddbdcc94c8ca5f7a5dca3a4a5a748c51477693"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3171f2dc3f02429d63cc568592b0ebebea0713ae2055e2bdd7220f8209fc4d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2646246c3fbc921a32e0bae1957db0d45e79de5dc5f106aa298a81798040db97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2646246c3fbc921a32e0bae1957db0d45e79de5dc5f106aa298a81798040db97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2646246c3fbc921a32e0bae1957db0d45e79de5dc5f106aa298a81798040db97"
    sha256 cellar: :any_skip_relocation, sonoma:        "01fdd40a9036906eb448f7ee00dbcc91786f29ff3d833b6816cf02838360dfd2"
    sha256 cellar: :any_skip_relocation, ventura:       "01fdd40a9036906eb448f7ee00dbcc91786f29ff3d833b6816cf02838360dfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13616c4fbe96395cf33157579f3eb1b473a146cfa4d43be73d8e862ca7b0ff0"
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
