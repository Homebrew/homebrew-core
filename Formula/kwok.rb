class Kwok < Formula
  desc "Kubernetes WithOut Kubelet - Simulates thousands of Nodes and Clusters"
  homepage "https://kwok.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/kwok/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3bfcde29f5fac4a045f55003320e2d53901e4b27899485c24f6f558ef69e03cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8154b855e0cb4dc736131ecc855d63bfa71db3641fb9dc3ac895b7effd33f634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be008c29377d1a83baf31bd079f67d209b423debab343dfb5c705c7fe7172e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4aa174b532e3d455dd62e09be33040114f721c030f5b60fe534135a1081354a"
    sha256 cellar: :any_skip_relocation, ventura:        "2ed7778ae6d1e0a49316ed54cac6a2dd40fdbc8ceb90dd7b1ac33fb7f15a29c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c80f2d1932ecf86b37ecfbdff9284ce76edc805e37826d00efdb760ef7b2ff5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "20a8b3cc41ea699e07bbf0019fb101daa25c62b48a69ebe4fd8257cad6bcf80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ccc131975811b41837fd357e5afe884c4adccab5f49d81429c3e662ebee99a8"
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
