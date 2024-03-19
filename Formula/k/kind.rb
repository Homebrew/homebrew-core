class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e3e21c8d1c4566d0d255e16e65bbc39297c8f5db41e7ec38d9d62a1ac9e51980"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2480cb3a1cd2ac3130810d5e44eb6015bdb659882fc798e3807cfbb41a0f919"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de6e00f2d2ffdba4e9368dcab20957bfc579c68f38e8bf010a512d314c70759e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "777c57a42b30a6b5b7aaa4c3544be061aa9fc966067a1d7c54433119d88cf711"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc95382ecc2bbdbe3e8f95968b73500db4bed8d1de566449722472cc6bc55fff"
    sha256 cellar: :any_skip_relocation, ventura:        "b0e5c588307f18cb6ffbc2331c3fe413e28b02784795c8ab3d12b5d72178960a"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a6ffa9d943c8b48f94c99d9ad63b8a90332d15b4a6f138969649ebd61acfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f61e1b10f7e6b6834066a95c33ce07d992eee2b8ce44b7e1bdab77b7c2fdd6"
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
