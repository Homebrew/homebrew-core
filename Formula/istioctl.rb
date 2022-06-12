class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.14.1",
      revision: "f59ce19ec6b63bbb70a65c43ac423845f1129464"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd6ad6cff5b01db19f2190995e1e2b34167b23908de2c1380107702d2a524e11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd6ad6cff5b01db19f2190995e1e2b34167b23908de2c1380107702d2a524e11"
    sha256 cellar: :any_skip_relocation, monterey:       "ac46c14577dbcce6c0b378f78e8a8813ba0ac7ffcc01e1bb1c90e7c5fe0442ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac46c14577dbcce6c0b378f78e8a8813ba0ac7ffcc01e1bb1c90e7c5fe0442ed"
    sha256 cellar: :any_skip_relocation, catalina:       "ac46c14577dbcce6c0b378f78e8a8813ba0ac7ffcc01e1bb1c90e7c5fe0442ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c40fb94cdb8b8076d8f1c54a4db0be6c3d0a7f5a6d30601e699178d2bc79a5"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "bash")
    (bash_completion/"istioctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "zsh")
    (zsh_completion/"_istioctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "fish")
    (fish_completion/"istioctl.fish").write output
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
