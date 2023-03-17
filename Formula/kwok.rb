class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3bfcde29f5fac4a045f55003320e2d53901e4b27899485c24f6f558ef69e03cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6a27711bbb104ba7845258e6a2de993c5509117e9cc85084bf1c64119f1cca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "889009797e864e7253b5d1b9b99dc670dd4ab916eb6be09e9b9258c364357a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a88e248d4a92c3fa5a8333c3fe227aa2d51f21f72fe9677d7b4e584e497f76b"
    sha256 cellar: :any_skip_relocation, ventura:        "a2748deb629a8f4057651463f4d1195d966080d44394eb37eb65162c2b59f10a"
    sha256 cellar: :any_skip_relocation, monterey:       "41b9cc19836994c34d3292d43c03c1e861e2218d5540fb6a3d046e7e9feb821b"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fdc1769ee74766177523523d7d1c00288fc791b812cbc98a8d88ceec0cbde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f24b2f3fa9ff6a124e582783e394e3ae477d64b8cf21852552c4bc7d9a1618fd"
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
    output = shell_output("#{bin}/kwokctl --name=brew-test create cluster", 1)
    assert_match "Creating cluster", output
  end
end
