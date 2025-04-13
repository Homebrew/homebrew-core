class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "cb43f7574205448a7c89b53201c40db6055f1ceebf011051248f092c893fa1cb"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kwok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96bf4a8c5613e2a57f32ac3929d6817a5fc4bd0f6f8bce0a6c9d397011f00362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967d9e8944681c9a88a17d7322d127d87a84ac1cf2c29dfe055ace293b174e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d09a56e0bf39b14b8bcde6a84224797d31c5b18162f563b18393ee232717442c"
    sha256 cellar: :any_skip_relocation, sonoma:        "22651fd3b826e95d6891b50343655997d2f1213edef8725543b7223c9260720c"
    sha256 cellar: :any_skip_relocation, ventura:       "41d1ff97bd7d4880746520a000bbd24027375bc25f058e6e6232baa91ffb06ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57268c303d4a0b742d35ec91665f00b1bbfff8dd53d3ae9ad82cc197ce47b1a2"
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
    output = shell_output(create_cluster_cmd)
    assert_match "Cluster is creating", output
  end
end
