class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4b2dc27e4f0bb71fd70b6b829c12184f7c1e986a4692353b68f40ea142c79538"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebb25c932c570c8d1bc78a94839e31fc26ac685cfeecf50550c6b4af24b37a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b703010cea66ed465e3893d36a016c2c2f7d24e19fb315cd29bf81562f98d20c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df2a95be4491154e020a89bed532d0371f31314f7b6abde0496915c46e4e89c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad79b8ce64eb2df125a881478e05c588bd32b49ad6c7a3a4af7b9adcb245dbb"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3f6c1d432fe828f27bd28a4caf2191b596d5d5f3636fb744581e5e8028a2b4"
    sha256 cellar: :any_skip_relocation, monterey:       "2f823a9e8f00628e1e7b868dc16363116bd85d68c88d4efb77d2f2fcab84a763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7766f074b5851af3a713126e71dc2892bd10342987ff9bd81a45c017f2ee9dc7"
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
