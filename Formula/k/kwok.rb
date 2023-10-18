class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ef458377b375ffe5051466a78003414e02ecf88cea07b8f42970ff17a44b15bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e690c55d7e6c71fcb61cecf51d56db83e9bd34f707eb5300d62bc92a33fd1747"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7931a351a3f94108232572f90d68944643ad6d0010f08f38aa8d68bba7755f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447488728d9abf65b8e6f09fcd8a7cf201620a86ef8350822faec8fb686f5253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c048b0796895615d526c10b1f106d357523e29bc91ffc7b6cc81ca9e21e525"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cbb2e1f68c4ef7f1b405de397239297ebd7a6a114493eda67cb69201acc55a3"
    sha256 cellar: :any_skip_relocation, ventura:        "035ef4a8d5638539c54e6127d1d571bb6fd56352793fac60308406f85ba76c80"
    sha256 cellar: :any_skip_relocation, monterey:       "511e832335f868c5f3f5074797edfb4f242dd4578d356a25c46eae7019ac603d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1008cee6ec777de7c94b861e717c4bed20e1c813926112bcf297b2cf0418ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "750066b09a66d5a7b71eb37c1a3ba7c54ea8311722548420f178a58dffc6c2d8"
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
