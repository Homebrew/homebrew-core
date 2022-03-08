class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.12.0.tar.gz"
  sha256 "cd1d09921b3c8a0f58c6423e5706be0c6e556f0c3d2b9e62f42be59263b209bb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544f1036a81b47d91b8ad81360fde3c063a4add7d50977f90992c9cada3eeaf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2a2b35caeebe678726302b67ab3e1f72440baad3b3d2faf7150ffcf834c0223"
    sha256 cellar: :any_skip_relocation, monterey:       "eb73ee98fae1727acc28ed0dbc86ad6c6ee1178c84f43c25402e1fc71f97d189"
    sha256 cellar: :any_skip_relocation, big_sur:        "65f176fbfc2d8af2612cb8d92f5f89575a821fa4f08abe1bb565c8f8a5beaddb"
    sha256 cellar: :any_skip_relocation, catalina:       "78e39031c372fe01a862f80e64f245cdbf221ba3c9606f690d6d9e8bbe7446c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d565d46ce69dfa673243aa998ba4936a4f575e10f33b2877940f6bb7fdba00f"
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
