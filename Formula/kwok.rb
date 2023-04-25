class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b92c76283e83d26d32767ea0e723805f82658892ef075a239e01ed2310b5365f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad3e44cdee9fc889e3eb77205b9474f200a9ab5e52faca929493944c04ba3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53baa87fa3d25452f08e935e1154118267d93d9e8666c56880a22959d87ec497"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "741a5c1dcf175b62cf65ea338642e336fea65221be7f4a012658d7b40a5ada93"
    sha256 cellar: :any_skip_relocation, ventura:        "356e87401215503d895d8bffb8d79d147151cca6069de0ff444beb7ed887af72"
    sha256 cellar: :any_skip_relocation, monterey:       "9dbd9da2d37e4676b6997bdc96d6e935bed2cd88b36abee18b14816e4741df64"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd965d206faa11697c1fefe9618b39da26c142a45fbb77415fae3b9f6dfead7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6269129336617107b6f9946dbbb0492cb214015fd7586ae3554c211abef63c77"
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
