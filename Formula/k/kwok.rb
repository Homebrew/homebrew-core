class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b35fc2d99ca4e63c024169238cfae098ef55263804133d721d30a8dbcacbe7d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06fb9cb9aeb140d2fb65008517248e900a6f48be4a7e9f852dd9acc9c7773c3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01b7adc0d1ce6569d2d23d26fa343ecbdab1b623e039b4ba6c27464134a0a8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36b2b83779e4d645142120b23cccc9222935f81f42cbab28a50563877aad272a"
    sha256 cellar: :any_skip_relocation, sonoma:         "812cef46628bdc5b15108c44ffcbf75693ae114ac0c242ae359e2e65f24bc231"
    sha256 cellar: :any_skip_relocation, ventura:        "eab0c7dd6750a7b986ad942353ce320f83a1b2afa6358507cdfa0c0cec88d60b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3d89ac2bd83d454bb5db537b64931245c168f450e22582ec6264bf92194129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32736667ece33c43448faa196faf5711924b35899df213666250910d6c3d8ed2"
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

    create_cluster_cmd = "#{bin}/kwokctl --name=brew-test create cluster 2>&1"
    output = OS.mac? ? shell_output(create_cluster_cmd, 1) : shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end
