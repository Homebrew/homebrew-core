class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a7f6416e8f33cbbf0fde7024d41dc3d0e77cd2f80ac5974f2a1360ff904d3761"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50cffb63c927e5ea71d90ba8a72167f6ab0579471f996f44460cb3abeb542a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7baa5914bd60cd34d54b8caafc3e31e8e6ac6484521e6dfbc187258e1968bbba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01678893280d24bfbee6d8ac8d892322fbd0834c3dfca64c6969a4433ddd7108"
    sha256 cellar: :any_skip_relocation, ventura:        "01543acf6d0bf0c61adf7a0d9b2d05ea04634183a72ffce6e93d331fca53dad1"
    sha256 cellar: :any_skip_relocation, monterey:       "4feecefb74e4db12773cd56ef6794f6e90096217b3df755a7edc5ffa6aed0161"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bccf22f00bb261c6afec78a1669cf1c71282ff3a10abc82252a4494491d22d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5fa3cd873c3b2f53010c3c82c31b96097e72eec8a652d43ad219b6948d9971"
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
