class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6b0ee90f5288e73b440e3724bcbafba6988016aa85bd93f32c474c3a1bffbe4f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kwok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "420e35fbbd71f2f9e1da1f0de80749516abf71b8672a0fadd850f097ec65f851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78bef0f7271b0483309997c9a475f2ed0f26024b50e7f975b930bfdac983e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d355b9230776cd0912e0d0089115b1491c532613fc1f3c69bec91ccc19410b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a5c0a65312699048aeb5cb1699791237da18950da5a7c5ba5e8556e1831c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fffaebcb815d11677ad32fbf8e8535696a020a86ed3e7c27fbe521c44405202e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2972416b9cc071a38241938990d93cb77a99e612627494699b495cf7ab8db34"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "make", "build", "VERSION=v#{version}"

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwok"
    bin.install "bin/#{OS.kernel_name.downcase}/#{arch}/kwokctl"

    %w[kwok kwokctl].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/kwok --version")
    assert_match version.to_s, shell_output("#{bin}/kwokctl --version")

    create_cluster_cmd = "#{bin}/kwokctl --name=brew-test create cluster 2>&1"
    output = shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end
