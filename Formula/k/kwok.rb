class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e88d952645e10d482c144fb8861136d0523bbf5c45f26dc29e194766c8b1763f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f95d5fa8ad473d38346ce9c6f942f3a7c36e9827a95ed03b249217b636cdb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e1c096f071526e5edc0ffb5d1f632e74b4b363daae71e9c0694c6c455a6f30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41b6d69bbe38b409932d2fb88ecce0addecd247cc235983b0fa3f13fd0a249fb"
    sha256 cellar: :any_skip_relocation, ventura:        "b0184e5a3f43fd2ae2d08a0e31a26149279faa758b48262499f03ac0f8d407f8"
    sha256 cellar: :any_skip_relocation, monterey:       "78e53773c8dea6021b3091f41d956315d5d128f39b0e2f67fc385ec9da2db5d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "70378dbcdd67d6a5c029f50b6fabd0f566510907692a615e17b786df13ada7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95118535655cd6e618779a8717ad155048cb8f5044f5f271c16c05bb7d0c349"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "make", "build", "VERSION=v#{version}"

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwok"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwokctl"

    generate_completions_from_executable("#{bin}/kwokctl", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/kwok --version")
    assert_match version.to_s, shell_output("#{bin}/kwokctl --version")

    create_cluster_cmd = "#{bin}/kwokctl --name=brew-test create cluster"
    output = OS.mac? ? shell_output(create_cluster_cmd, 1) : shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end
