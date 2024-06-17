class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "b8ea6665bc37a34de0a6fe7592fb8ae376847e1c93fc5d6377140a98c1aa6a55"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d26c2f1f12e2ece9f3d7e97b94061a5bdabde6590914ddaa9a2db3456171d3b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36694642b8fab22f85b2f7e9c2efc8909be215c1a7d26437aa6c79c0d24a5d0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca7a35c8a1493f82c9a2a5af829cb6ec56ddfa4ba26c32b5f017d2a6c9a511bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "68bb2b50d98e59444a66f056db2d70714c710aa72a946fef4e4539e3c10105cc"
    sha256 cellar: :any_skip_relocation, ventura:        "8e2e9f470da03c8f0b311aaf6bb634b4b4fb984ad1914a35b8ab8b8c666a7c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "867e425f12c418b179eccc4d5321d8e353dbe202ffca0632b472c49263bdb98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26c16e33b3ad3baa0ed37d1686cb579ed2571449880d1b88fd8b4fe8154a324"
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
