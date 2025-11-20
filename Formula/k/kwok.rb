class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "bf7c686c3ada070104f32fd3263686368cc981206770e81d39d8a27ae04368c0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kwok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da59fb00ae242492055b677af311bf49f0c7ae14877eb9216edd3ce647e2cc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ca4b4f59d0ef9c01ede4c2ca158428f53f35bae8cf57d2b3c374fe32927230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10477738cc0f5a6ccd4bd9f5dba951e0094e14d48178a35ad471f373553878b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c6429022bffc022ed2b64e3dd81dd5207e8ee0d42350e8e0d530d7ec298bbb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "481cdb115719ed6de328dcd241de02069e57dda4a964bade6ae11ea97133f1ee"
    sha256 cellar: :any_skip_relocation, ventura:       "ddaf6d75cd5c04d5f872d8152f3c550388096185d62ac97f1230e0f3cad046c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a7a6767343dab0abab8c18b6d27792013ab03cd0adfe8952420b250890002d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74d3089b75892e4629a723c08daed077484c0ffa7c2b5726f8c95b77472780b"
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
