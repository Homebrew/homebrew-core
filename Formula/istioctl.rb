class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.0",
      revision: "75ee7514615d3a642a7eabaa0ad7c22cea1a1ed0"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef1bb48ebfe4f758920564545a41de5fc75ef4cc86cc0d1e1c9620e56fe4e536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef1bb48ebfe4f758920564545a41de5fc75ef4cc86cc0d1e1c9620e56fe4e536"
    sha256 cellar: :any_skip_relocation, monterey:       "c288cd0a2e944ef46e44e2b68479baf163cad3c689938c7fe3c373eeed8ea40e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c288cd0a2e944ef46e44e2b68479baf163cad3c689938c7fe3c373eeed8ea40e"
    sha256 cellar: :any_skip_relocation, catalina:       "c288cd0a2e944ef46e44e2b68479baf163cad3c689938c7fe3c373eeed8ea40e"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
