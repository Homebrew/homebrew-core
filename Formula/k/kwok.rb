class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4973521fc179ff2edad75c12d7862818e9cc0ae97eb85c4c160b67f9af1378ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f5506c72f4bf76ff90f9f65eb16bcec253c644e64f3fd1093de96d206ac3643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6139018d596f2b3a6eee4ade78527ac2beab6c76ab00a3f59a76e533db3da6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe7b96b2c2b158b0a067693230bd8860f22229db4161f732a3446fcfa9ee5e15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fca9403e495eacec9197b9640187d10d541f4cd8c7816e2beb62af295854f8c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "352d40f2d801b7a237cfb8825b41fdb35a1dae8e9cfe6901e86ff496d6b57d8c"
    sha256 cellar: :any_skip_relocation, ventura:        "63fbdc0ab304f8e1530d5bb09b7b1fe62edfae52a15da2697dc7ab6fdd0f2f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "d52f43bebc002a0c091072e4c7c40a8661e99e6e2132569f6a90116260ac2418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6c218e3bde8e75ce945cf7e1793e984e35a66e877b86c36e50887961f36b23"
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
